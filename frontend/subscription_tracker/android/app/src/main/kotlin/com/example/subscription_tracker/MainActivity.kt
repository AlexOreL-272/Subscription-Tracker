package com.example.subscription_tracker

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.appwidget.AppWidgetManager
import android.content.ComponentName

import com.example.subscription_tracker.R

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.subscription_tracker/update_widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateWidget") {
                updateWidget()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun updateWidget() {
        val appWidgetManager = AppWidgetManager.getInstance(applicationContext)
        val ids = appWidgetManager.getAppWidgetIds(
            ComponentName(applicationContext, TaskWidgetProvider::class.java)
        )
        
        appWidgetManager.notifyAppWidgetViewDataChanged(ids, R.id.task_list_view)
        
        val intent = Intent(applicationContext, TaskWidgetProvider::class.java)
        intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
        sendBroadcast(intent)
    }
}
