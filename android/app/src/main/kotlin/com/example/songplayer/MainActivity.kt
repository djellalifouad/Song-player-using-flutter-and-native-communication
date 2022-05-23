package com.example.songplayer

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.Color
import android.icu.number.NumberFormatter.with
import android.media.AudioManager
import android.media.MediaPlayer
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

import java.io.IOException
import java.util.*
import android.content.BroadcastReceiver
import java.sql.DriverManager.println
import com.example.songplayer.player.MediaPlayerService as MediaPlayerService
class MainActivity: FlutterActivity()   {
    lateinit var notificationManager: NotificationManager
    lateinit var notificationChannel: NotificationChannel
    lateinit var builder: Notification.Builder
    private val channelId = "i.apps.notifications"
    private val description = "Test notification"
     val CHANNEL = "flutter.native.audio.bridge"
    private val media  = MediaPlayerService();

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onCreate(savedInstanceState: Bundle?) {




        var currentPostion  = 0;
        var currentIndex = 0;

        var listSongs: List<Map<String,String>>?;
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))

        var seekBarProgressHandler = Handler()
        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).setMethodCallHandler { methodCall, result ->
            when (methodCall.method) {
                "startPlayer" -> {
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                        StartService(methodCall.argument<List<Map<String,String>>>("list") as ArrayList<Map<String, String>>,methodCall.argument<Int>("index")!!);
                    }
                }
                "pausePlayer" -> {
                 PauseService()
                }
                "resumePlayer" -> {
                 ResumeService()
                }

                "getState" -> {

                }
            }
        }
    }
    private fun StartService(list : ArrayList<Map<String,String>>  ,currentIndex  : Int ) {
        val intent = Intent(applicationContext, MediaPlayerService::class.java,)
        intent.action = "start";
        System.out.println(currentIndex)
        intent.putExtra("list", list)
        intent.putExtra("index",currentIndex)
        startService(intent)
    }
    private fun PauseService() {
        val intent = Intent(applicationContext, MediaPlayerService::class.java,)
           intent.action = "pause";
        startService(intent)
    }
    private fun ResumeService() {
        val intent = Intent(applicationContext, MediaPlayerService::class.java,)
        intent.action = "resume";
        startService(intent)
    }
    private fun StopService() {
        stopService(Intent(applicationContext, MediaPlayerService::class.java))
    }
}




