package ru.kodazm.cleaner.junk

import android.app.Activity
import android.app.ActivityManager
import android.content.Context
import android.os.Environment
import android.os.StatFs
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import ru.kodazm.cleaner.pigeons.junk.Stats
import java.io.IOException
import java.io.RandomAccessFile
import java.util.regex.Pattern

class JunkStats(
    val memory: Memory,
    val storage: Storage,
) : Stats.JunkStats {
    override fun storage(result: Stats.Result<Stats.StatsResponse>?) {
        val response = Stats.StatsResponse();

        runBlocking {
            launch {
                val total = storage.total()

                response.total = total
                response.used = total - storage.available()

                result?.success(response)
            }
        }
    }

    override fun memory(result: Stats.Result<Stats.StatsResponse>?) {
        val response = Stats.StatsResponse();

        runBlocking {
            launch {
                val total = memory.total()

                response.total = total
                response.used = total - memory.available()

                result?.success(response)
            }
        }
    }
}

class Memory(val activity: Activity) {
    fun total(): Long {
        var ram: Long = 0
        try {
            val reader = RandomAccessFile("/proc/meminfo", "r")
            val load = reader.readLine()

            val p = Pattern.compile("(\\d+)")
            val m = p.matcher(load)
            var value = ""
            while (m.find()) {
                value = m.group(1)
            }
            reader.close()
            ram = Integer.valueOf(value).toLong()
        } catch (ex: IOException) {
            ex.printStackTrace()
        } finally {
//             Streams.close(reader);
        }
        return ram * 1024
    }

    fun available(): Long {
        val info = ActivityManager.MemoryInfo()
        val manager = activity.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager?

        manager?.getMemoryInfo(info);

        return info.availMem
    }
}

class Storage {
    fun total(): Long {
        val statFs = StatFs(Environment.getExternalStorageDirectory().path)
        return statFs.blockSize.toLong() * statFs.blockCount.toLong()
    }

    fun available(): Long {
        val stat = StatFs(Environment.getExternalStorageDirectory().path)
        return stat.blockSize.toLong() * stat.availableBlocks.toLong()
    }
}