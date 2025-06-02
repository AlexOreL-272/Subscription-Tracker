package com.example.subscription_tracker

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDate
import java.time.format.DateTimeFormatter

import java.time.LocalDateTime

data class Subscription(
    val caption: String,
    val currency: String,
    val firstPay: LocalDateTime,
    val cost: Double
)

class TaskRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var subs: List<Subscription> = listOf()
    private val TAG = "TaskRemoteViewsFactory"

    override fun onCreate() {
        Log.d(TAG, "onCreate")
        loadSubscriptions()
    }

    override fun onDataSetChanged() {
        Log.d(TAG, "onDataSetChanged called")
        loadSubscriptions()
        Log.d(TAG, "Loaded ${subs.size} subscriptions")
    }

    private fun loadSubscriptions() {
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val subsString = prefs.getString("flutter.subscriptions", "[]")
        Log.d(TAG, "Loading subscriptions from prefs: $subsString")

        try {
            val jsonArray = JSONArray(subsString)
            val loadedSubs = mutableListOf<Subscription>()
            for (i in 0 until jsonArray.length()) {
                val jsonObject = jsonArray.getJSONObject(i)
                val sub = Subscription(
                    caption = jsonObject.getString("caption"),
                    currency = jsonObject.getString("currency"),
                    firstPay = LocalDateTime.parse(jsonObject.getString("firstPay")),
                    cost = jsonObject.getDouble("cost")
                )
                loadedSubs.add(sub)
            }
            subs = loadedSubs
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing subscriptions: ${e.message}", e)
            subs = emptyList()
        }
    }

    override fun onDestroy() {
        subs = emptyList()
    }

    override fun getCount(): Int = subs.size

    override fun getViewAt(position: Int): RemoteViews {
        val sub = subs[position]
        val day = sub.firstPay.dayOfMonth.toString()
        val month = sub.firstPay.month.toString().substring(0, 1) + sub.firstPay.month.toString().substring(1).lowercase()
    
        val remoteViews = RemoteViews(context.packageName, R.layout.task_item)
        remoteViews.setTextViewText(R.id.date_day, day)
        remoteViews.setTextViewText(R.id.date_month, month)
        remoteViews.setTextViewText(R.id.sub_caption, sub.caption)
        remoteViews.setTextViewText(R.id.sub_cost, "${sub.cost} ${sub.currency}")
        return remoteViews
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
}
