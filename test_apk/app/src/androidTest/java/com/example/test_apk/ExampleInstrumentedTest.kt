package com.example.test_apk

import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.ext.junit.runners.AndroidJUnit4

import org.junit.Test
import org.junit.runner.RunWith
import android.util.Log

import org.junit.Assert.*

/**
 * Instrumented test, which will execute on an Android device.
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
@RunWith(AndroidJUnit4::class)
class ExampleInstrumentedTest {
    @Test
    fun useAppContext() {
        // Context of the app under test.
        Log.i("🔍TestLogPrint", "✅ Starting test...")
        val context = InstrumentationRegistry.getInstrumentation().targetContext
        Log.i("🔍TestLogPrint", "Package name: ${context.packageName}")
        assertTrue("True should be true", true)
        Log.i("🔍TestLogPrint", "✅ Test finished successfully")
    }
}