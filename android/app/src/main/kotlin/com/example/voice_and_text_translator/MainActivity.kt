package com.example.voice_and_text_translator

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}
