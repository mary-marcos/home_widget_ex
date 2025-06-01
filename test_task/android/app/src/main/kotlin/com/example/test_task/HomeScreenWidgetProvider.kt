package com.example.test_task






import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class HomeScreenWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        //Android allows users to add multiple instances of the same widget to their home screen. Each instance has a unique ID assigned by the system. 
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {

                //this will Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                // This is the key for adding the string from the flutter side
                val name = widgetData.getString("_name", "No Name Set") ?: "No Name Set"


                setTextViewText(R.id.tv_name, name)



                  val incrementIntent = HomeWidgetBackgroundIntent.getBroadcast(
                        context,
                        Uri.parse("homeWidgetCounter://increment")
                )
                setOnClickPendingIntent(R.id.incrementButton, incrementIntent)





            }




            appWidgetManager.updateAppWidget(widgetId, views)    // Updates the Widget UI (appWidgetManager.updateAppWidget)
        }
    }
}