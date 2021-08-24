package com.openjmu.iJMU

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (
                (!isTaskRoot
                        && intent != null
                        && intent.hasCategory(Intent.CATEGORY_LAUNCHER)
                        && intent.action != null
                        && intent.action == Intent.ACTION_MAIN) ||
                intent.flags and Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT != 0
        ) {
            finish()
            return
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        Log.i("OpenJMU", "MainActivity - onActivityResult")
    }

    override fun onPostResume() {
        super.onPostResume()
        WindowCompat.setDecorFitsSystemWindows(window, false)
        window.apply {
            navigationBarColor = 0
            statusBarColor = 0
        }
    }
}
