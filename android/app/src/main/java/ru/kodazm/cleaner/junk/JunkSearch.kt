package ru.kodazm.cleaner.junk

import ru.kodazm.cleaner.MainActivity
import ru.kodazm.cleaner.utils.Prefs
import ru.kodazm.cleaner.pigeons.junk.Search
import android.graphics.Bitmap
import ru.kodazm.cleaner.pigeons.junk.Search.SearchResponse
import android.content.Intent
import android.os.Build
import android.content.pm.ApplicationInfo
import android.app.usage.StorageStatsManager
import android.content.Context
import android.content.pm.PackageManager
import android.content.pm.IPackageStatsObserver
import kotlin.Throws
import android.content.pm.PackageStats
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.Environment
import android.os.RemoteException
import android.util.Base64
import kotlinx.coroutines.*
import org.json.JSONException
import org.json.JSONObject
import java.io.ByteArrayOutputStream
import java.io.File
import java.lang.Exception
import java.lang.reflect.InvocationTargetException
import java.lang.reflect.Method
import java.util.ArrayList
import kotlin.time.Duration
import kotlin.time.ExperimentalTime

class JunkSearch(private val activity: MainActivity, private val prefs: Prefs) : Search.JunkSearch {
    @ExperimentalTime
    override fun getApkFiles(result: Search.Result<SearchResponse>) {
        val reply = SearchResponse()
        ScanApkFiles(object : OnScanFilesListener {
            override fun onCompleted(size: Long, files: List<FileItem>) {
                val items: MutableList<Any> = ArrayList()
                for (file in files) {
                    items.add(file.toJson())
                }
                reply.items = items
                reply.size = size
                result.success(reply)
            }
        }).doInBackground()
    }

    @ExperimentalTime
    override fun getCacheFiles(result: Search.Result<SearchResponse>) {
        val reply = SearchResponse()
        ScanCacheFiles(object : OnScanFilesListener {
            override fun onCompleted(size: Long, files: List<FileItem>) {
                val items: MutableList<Any> = ArrayList()
                for (file in files) {
                    items.add(file.toJson())
                }
                reply.items = items
                reply.size = size
                result.success(reply)
            }
        }).doInBackground()
    }

    @ExperimentalTime
    override fun getDownloadFiles(result: Search.Result<SearchResponse>) {
        val reply = SearchResponse()
        ScanDownloadFiles(object : OnScanFilesListener {
            override fun onCompleted(size: Long, files: List<FileItem>) {
                val items: MutableList<Any> = ArrayList()
                for (file in files) {
                    items.add(file.toJson())
                }
                reply.items = items
                reply.size = size
                result.success(reply)
            }
        }).doInBackground()
    }

    @ExperimentalTime
    override fun getLargeFiles(result: Search.Result<SearchResponse>) {
        val reply = SearchResponse()
        ScanLargeFiles(object : OnScanFilesListener {
            override fun onCompleted(size: Long, files: List<FileItem>) {
                val items: MutableList<Any> = ArrayList()
                for (file in files) {
                    items.add(file.toJson())
                }
                reply.items = items
                reply.size = size
                result.success(reply)
            }
        }).doInBackground()
    }

    interface OnScanFilesListener {
        fun onCompleted(size: Long, files: List<FileItem>)
    }

    private inner class ScanApkFiles(private val listener: OnScanFilesListener?) {
        @ExperimentalTime
        fun doInBackground() {
            GlobalScope.launch {
                var total: Long = 0
                val items: MutableList<FileItem> = ArrayList()

                val download = File(Environment.getExternalStorageDirectory().absolutePath)
                val files = download.listFiles()
                if (files.isNullOrEmpty()) {
                    withContext(Dispatchers.Main) {
                        listener?.onCompleted(total, items)
                    }
                    return@launch
                }

                for (file in files) {
                    if (!file.name.endsWith(".apk")) {
                        continue
                    }
                    val item = FileItem(
                        file.length(),
                        file.name,
                        file.name,
                        "",
                        FileItem.Companion.TYPE_APKS,
                        file.path
                    )
                    items.add(item)
                    total = file.length()
                }

                delay(duration = Duration.seconds(4))

                withContext(Dispatchers.Main) {
                    listener?.onCompleted(total, items)
                }
            }
        }
    }

    private inner class ScanCacheFiles(private val listener: OnScanFilesListener?) {
        @ExperimentalTime
        fun doInBackground() {
            GlobalScope.launch {

                var total: Long = 0
                val apps: MutableList<FileItem> = ArrayList()

                val intent = Intent(Intent.ACTION_MAIN, null)
                intent.addCategory(Intent.CATEGORY_LAUNCHER)
                val pkgs = activity.packageManager.queryIntentActivities(intent, 0)
                for (pkg in pkgs) {
                    if (Build.VERSION.SDK_INT > Build.VERSION_CODES.O) { // new versions
                        try {
                            val info = activity.packageManager.getApplicationInfo(pkg.activityInfo.packageName, 0)
                            val statsManager = activity.getSystemService(Context.STORAGE_STATS_SERVICE) as StorageStatsManager
                            val stats = statsManager.queryStatsForUid(info.storageUuid, info.uid)
                            val packageManager = activity.packageManager
                            val size = stats.cacheBytes
                            if (size < 1024 * 100) {
                                continue
                            }
                            if (prefs.isCleanCache(info.packageName)) {
                                continue
                            }
                            apps.add(
                                FileItem(
                                    size, info.packageName, packageManager.getApplicationLabel(info).toString(),
                                    convertBitmapToBase64(
                                        getBitmapFromDrawable(
                                            info.loadIcon(
                                                packageManager
                                            )
                                        )
                                    ),
                                    FileItem.Companion.TYPE_CACHE,
                                    null
                                )
                            )
                            total += size
                        } catch (e: PackageManager.NameNotFoundException) {
                            e.printStackTrace()
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    } else { // old versions
                        var getPackageSizeInfo: Method? = null
                        getPackageSizeInfo = try {
                            activity.packageManager.javaClass.getMethod(
                                "getPackageSizeInfo",
                                String::class.java,
                                IPackageStatsObserver::class.java
                            )
                        } catch (e: NoSuchMethodException) {
                            e.printStackTrace()
                            continue
                        }
                        try {
                            getPackageSizeInfo?.invoke(activity.packageManager, pkg.activityInfo.packageName,
                                object : IPackageStatsObserver.Stub() {
                                    @Throws(RemoteException::class)
                                    override fun onGetStatsCompleted(
                                        stats: PackageStats,
                                        succeeded: Boolean
                                    ) {
                                        val size = stats.cacheSize
                                        if (size < 1024 * 100) { // && PreferenceUtils.isCleanCache(pgkName)
                                            return
                                        }
                                        val packageManager = activity.packageManager
                                        var info: ApplicationInfo? = null
                                        try {
                                            info = packageManager.getApplicationInfo(
                                                pkg.activityInfo.packageName,
                                                PackageManager.GET_META_DATA
                                            )
                                        } catch (e: PackageManager.NameNotFoundException) {
                                            e.printStackTrace()
                                        }
                                        apps.add(
                                            FileItem(
                                                size,
                                                pkg.activityInfo.packageName,
                                                packageManager.getApplicationLabel(info!!)
                                                    .toString(),
                                                "",
                                                FileItem.Companion.TYPE_CACHE,
                                                null
                                            )
                                        )
                                        total += size
                                    }
                                })
                        } catch (e: InvocationTargetException) {
                            e.printStackTrace()
                        } catch (e: IllegalAccessException) {
                            e.printStackTrace()
                        }
                    }
                }

                delay(duration = Duration.seconds(4))

                withContext(Dispatchers.Main) {
                    listener?.onCompleted(total, apps)
                }

            }
        }
    }

    private inner class ScanDownloadFiles(private val listener: OnScanFilesListener?) {
        @ExperimentalTime
        fun doInBackground() {
            GlobalScope.launch {
                var total: Long = 0
                val items: MutableList<FileItem> = ArrayList()

                val root = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).absolutePath)
                val files = root.listFiles()
                if (files.isNullOrEmpty()) {
                    delay(duration = Duration.seconds(4))

                    withContext(Dispatchers.Main) {
                        listener?.onCompleted(total, items)
                    }

                    return@launch
                }
                for (file in files) {
                    total += file.length()
                    items.add(
                        FileItem(
                            file.length(),
                            file.name,
                            file.name,
                            "",
                            FileItem.Companion.TYPE_DOWNLOAD_FILE,
                            file.path
                        )
                    )
                }

                delay(duration = Duration.seconds(4))

                withContext(Dispatchers.Main) {
                    listener?.onCompleted(total, items)
                }
            }
        }
    }

    private inner class ScanLargeFiles(private val listener: OnScanFilesListener?) {
        private var total: Long = 0

        @ExperimentalTime
        fun doInBackground() {
            GlobalScope.launch {
                val root = File(Environment.getExternalStorageDirectory().absolutePath)
                val items = scan(root)

                delay(duration = Duration.seconds(4))

                withContext(Dispatchers.Main) {
                    listener?.onCompleted(total, items)
                }
            }

        }

        private fun scan(root: File): List<FileItem> {
            val items: MutableList<FileItem> = ArrayList()
            val files = root.listFiles()
            if (files == null || files.size == 0) {
                return items
            }
            for (file in files) {
                if (file.isDirectory && file.name != Environment.DIRECTORY_DOWNLOADS) {
                    items.addAll(scan(file))
                } else {
                    val mb = file.length() / 1024 / 1024
                    if (mb < 10 || file.name.endsWith(".apk")) {
                        continue
                    }
                    total += file.length()
                    items.add(
                        FileItem(
                            file.length(),
                            file.name,
                            file.name,
                            "",
                            FileItem.Companion.TYPE_LARGE_FILES,
                            file.path
                        )
                    )
                }
            }
            return items
        }
    }


    companion object {
        private fun getBitmapFromDrawable(drawable: Drawable): Bitmap {
            val bmp = Bitmap.createBitmap(
                drawable.intrinsicWidth,
                drawable.intrinsicHeight,
                Bitmap.Config.ARGB_8888
            )
            val canvas = Canvas(bmp)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            return bmp
        }

        fun convertBitmapToBase64(bitmap: Bitmap): String {
            val outputStream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
            return Base64.encodeToString(
                outputStream.toByteArray(),
                Base64.DEFAULT or Base64.NO_WRAP
            )
        }
    }
}

class FileItem internal constructor(
    var size: Long,
    var packageName: String,
    var applicationName: String,
    var icon: String,
    var type: Int,
    var path: String?
) {
    fun toJson(): String {
        val json = JSONObject()
        try {
            json.put("size", size)
            json.put("packageName", packageName)
            json.put("applicationName", applicationName)
            json.put("icon", icon)
            json.put("type", type)
            json.put("path", path)
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        return json.toString()
    }

    companion object {
        const val TYPE_APKS = 0
        const val TYPE_CACHE = 1
        const val TYPE_DOWNLOAD_FILE = 2
        const val TYPE_LARGE_FILES = 3
    }
}
