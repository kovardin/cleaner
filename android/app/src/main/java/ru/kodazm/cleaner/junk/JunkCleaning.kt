package ru.kodazm.cleaner.junk

import android.content.Context;
import android.content.IntentSender
import android.content.pm.PackageManager
import android.util.Log
import com.beust.klaxon.Klaxon
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

import ru.kodazm.cleaner.pigeons.junk.Cleaning.JunkCleaning;
import ru.kodazm.cleaner.pigeons.junk.Cleaning.CleaningRequest;
import ru.kodazm.cleaner.pigeons.junk.Cleaning.Result;
import ru.kodazm.cleaner.pigeons.junk.Cleaning.CleaningResponse;
import ru.kodazm.cleaner.utils.Prefs
import java.io.File
import java.io.IOException
import java.lang.reflect.InvocationTargetException
import java.lang.reflect.Method


data class JunkFile(
    val applicationName: String,
    val packageName: String,
    val path: String,
    val type: Int,
)

open class JunkCleaning(
    val context: Context,
    val prefs: Prefs,
) : JunkCleaning {

    override fun clean(request: CleaningRequest?, result: Result<CleaningResponse>?) {
        GlobalScope.launch {
            for (item in request?.files!!) {

                val file = Klaxon()
                    .parse<JunkFile>(item)

                when (file?.type) {
                    FileItem.TYPE_APKS,
                    FileItem.TYPE_DOWNLOAD_FILE,
                    FileItem.TYPE_LARGE_FILES -> cleanFile(file)
                    FileItem.TYPE_CACHE -> cleanCache(file)
                }
            }

            withContext(Dispatchers.Main) {
                val response = CleaningResponse();
                response.status = true;
                result?.success(response)
            }
        }
    }

    private fun cleanCache(item: JunkFile) {
        val manager: PackageManager = context.packageManager
        try {
            val call: Method = context.packageManager.javaClass.getMethod(
                "freeStorage", String::class.java, Long::class.java, IntentSender::class.java
            )
            val free = (8 * 1024 * 1024 * 1024).toLong()
            call.invoke(manager, item.packageName, free, null)
        } catch (e: NoSuchMethodException) {
            e.printStackTrace()
        } catch (e: IllegalAccessException) {
            e.printStackTrace()
        } catch (e: InvocationTargetException) {
            e.printStackTrace()
        }

        prefs.setTimePkgCleanCache(item.packageName)
    }

    private fun cleanFile(item: JunkFile) {
        val file = File(item.path)
        file.delete()
        if (file.exists()) {
            try {
                file.canonicalFile.delete()
                if (file.exists()) {
                    context.deleteFile(file.name)
                }
            } catch (e: IOException) {
            }
        }
    }

}