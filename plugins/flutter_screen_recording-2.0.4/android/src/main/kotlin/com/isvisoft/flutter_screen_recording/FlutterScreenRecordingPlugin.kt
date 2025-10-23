package com.isvisoft.flutter_screen_recording

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.MediaRecorder
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.util.DisplayMetrics
import android.util.Log
import androidx.core.app.ActivityCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.IOException

import com.foregroundservice.ForegroundService

class FlutterScreenRecordingPlugin(
    private val registrar: Registrar
) : MethodCallHandler, PluginRegistry.ActivityResultListener{

    var mMediaRecorder: MediaRecorder? = null
    var mProjectionManager: MediaProjectionManager? = null
    var mMediaProjection: MediaProjection? = null
    var mMediaProjectionCallback: MediaProjectionCallback? = null
    var mVirtualDisplay: VirtualDisplay? = null
    var videoName: String? = ""
    var mFileName: String? = ""
    var recordAudio: Boolean? = false;
    private val SCREEN_RECORD_REQUEST_CODE = 333
    var mDisplayWidth: Int = 0
    var mDisplayHeight: Int = 0
    var mScreenDensity: Int = 0

    private lateinit var _result: MethodChannel.Result

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_screen_recording")
            val plugin = FlutterScreenRecordingPlugin(registrar)
            channel.setMethodCallHandler(plugin)
            registrar.addActivityResultListener(plugin)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == SCREEN_RECORD_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                try {
                    mMediaProjectionCallback = MediaProjectionCallback()
                    mMediaProjection = mProjectionManager?.getMediaProjection(resultCode, data!!)
                    mMediaProjection?.registerCallback(mMediaProjectionCallback, null)

                    // 先准备MediaRecorder
                    prepareMediaRecorder()

                    // 然后创建虚拟显示
                    mVirtualDisplay = createVirtualDisplay()

                    // 开始录制
                    mMediaRecorder?.start()
                    _result.success(true)
                    return true
                } catch (e: Exception) {
                    Log.e("ScreenRecording", "Error starting recording: ${e.message}")
                    _result.success(false)
                    return false
                }
            } else {
                _result.success(false)
            }
        }
        return false
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "startRecordScreen" || call.method == "startRecordScreenAndAudio") {
            try {
                _result = result
                ForegroundService.startService(registrar.context(), "Your screen is being recorded")
                mProjectionManager = registrar.context().applicationContext.getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager?

                val metrics = DisplayMetrics()
                val activity = registrar.activity()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    activity?.display?.getRealMetrics(metrics)
                } else {
                    @Suppress("DEPRECATION")
                    activity?.windowManager?.defaultDisplay?.getMetrics(metrics)
                }
                mDisplayWidth = metrics.widthPixels
                mDisplayHeight = metrics.heightPixels
                mScreenDensity = metrics.densityDpi

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    mMediaRecorder = MediaRecorder(registrar.context().applicationContext)
                } else {
                    @Suppress("DEPRECATION")
                    mMediaRecorder = MediaRecorder()
                }
                videoName = call.argument<String?>("name")
                recordAudio = call.argument<Boolean?>("audio")

                // 只请求权限，不立即开始录制
                requestScreenCapturePermission()
            } catch (e: Exception) {
                Log.e("ScreenRecording", "Error in onMethodCall: ${e.message}")
                result.success(false)
            }
        } else if (call.method == "stopRecordScreen") {
            try {
                ForegroundService.stopService(registrar.context())
                if (mMediaRecorder != null) {
                    stopRecordScreen()
                    result.success(mFileName)
                } else {
                    result.success("")
                }
            } catch (e: Exception) {
                Log.e("ScreenRecording", "Error stopping recording: ${e.message}")
                result.success("")
            }
        } else {
            result.notImplemented()
        }
    }

    private fun requestScreenCapturePermission() {
        val permissionIntent = mProjectionManager?.createScreenCaptureIntent()
        ActivityCompat.startActivityForResult(registrar.activity()!!, permissionIntent!!, SCREEN_RECORD_REQUEST_CODE, null)
    }

    private fun prepareMediaRecorder() {
        try {
            mFileName = registrar.context().getExternalCacheDir()?.absolutePath
            mFileName += "/$videoName.mp4"

            mMediaRecorder?.setVideoSource(MediaRecorder.VideoSource.SURFACE)
            if (recordAudio == true) {
                mMediaRecorder?.setAudioSource(MediaRecorder.AudioSource.MIC)
            }

            mMediaRecorder?.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            mMediaRecorder?.setOutputFile(mFileName)
            mMediaRecorder?.setVideoSize(mDisplayWidth, mDisplayHeight)
            mMediaRecorder?.setVideoEncoder(MediaRecorder.VideoEncoder.H264)

            // 增加比特率和帧率以提高质量
            mMediaRecorder?.setVideoEncodingBitRate(2 * 1024 * 1024)
            mMediaRecorder?.setVideoFrameRate(15)

            if (recordAudio == true) {
                mMediaRecorder?.setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
                mMediaRecorder?.setAudioEncodingBitRate(128 * 1024)
                mMediaRecorder?.setAudioSamplingRate(44100)
            }

            mMediaRecorder?.prepare()
        } catch (e: IOException) {
            Log.e("ScreenRecording", "Error preparing MediaRecorder: ${e.message}")
            throw e
        }
    }

    private fun createVirtualDisplay(): VirtualDisplay? {
        try {
            return mMediaProjection?.createVirtualDisplay(
                "ScreenRecording", mDisplayWidth, mDisplayHeight, mScreenDensity,
                DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR, mMediaRecorder?.surface, null, null
            )
        } catch (e: Exception) {
            Log.e("ScreenRecording", "Error creating virtual display: ${e.message}")
            return null
        }
    }

    fun stopRecordScreen() {
        try {
            mMediaRecorder?.stop()
            mMediaRecorder?.reset()
            Log.d("ScreenRecording", "Recording stopped successfully")
        } catch (e: Exception) {
            Log.e("ScreenRecording", "Error stopping recording: ${e.message}")
        } finally {
            stopScreenSharing()
        }
    }

    private fun stopScreenSharing() {
        if (mVirtualDisplay != null) {
            mVirtualDisplay?.release()
            mVirtualDisplay = null
        }
        if (mMediaProjection != null) {
            mMediaProjection?.unregisterCallback(mMediaProjectionCallback)
            mMediaProjection?.stop()
            mMediaProjection = null
        }
        if (mMediaRecorder != null) {
            mMediaRecorder?.release()
            mMediaRecorder = null
        }
        Log.d("ScreenRecording", "Screen sharing stopped")
    }

    inner class MediaProjectionCallback : MediaProjection.Callback() {
        override fun onStop() {
            try {
                mMediaRecorder?.stop()
            } catch (e: Exception) {
                Log.e("ScreenRecording", "Error in onStop: ${e.message}")
            }
            stopScreenSharing()
        }
    }
}