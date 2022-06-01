package ru.kodazm.cleaner.utils

import android.annotation.SuppressLint
import android.content.Context

open class Prefs(val context: Context) {
    val PREFS = "cleaner_prefs";
    val CLEAN_CACHE = "clean_cache";

    @SuppressLint("CommitPrefEdits")
    fun setTimePkgCleanCache(packageName: String) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

        prefs.edit()
            .putLong(
                CLEAN_CACHE + "_" + packageName,
                System.currentTimeMillis()
            ).apply()
    }

    fun isCleanCache(packageName: String): Boolean {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

        return prefs.getLong(CLEAN_CACHE + "_" + packageName, 0) > (java.util.Random().nextInt(30) + 10) * 60 * 1000
    }
}
