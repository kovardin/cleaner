package ru.kodazm.cleaner

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import ru.kodazm.cleaner.junk.*
import ru.kodazm.cleaner.pigeons.junk.Search
import ru.kodazm.cleaner.utils.Prefs
import ru.kodazm.cleaner.pigeons.junk.Cleaning
import ru.kodazm.cleaner.pigeons.junk.Stats

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Search.JunkSearch.setup(
            flutterEngine.dartExecutor.binaryMessenger,
            JunkSearch(activity = this, prefs = Prefs(this))
        )
        Cleaning.JunkCleaning.setup(
            flutterEngine.dartExecutor.binaryMessenger,
            JunkCleaning(context = this, prefs = Prefs(this))
        )
        Stats.JunkStats.setup(
            flutterEngine.dartExecutor.binaryMessenger,
            JunkStats(memory = Memory(activity = this), storage = Storage())
        )
    }
}