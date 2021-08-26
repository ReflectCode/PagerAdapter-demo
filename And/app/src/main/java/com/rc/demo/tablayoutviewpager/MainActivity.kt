package com.rc.demo.tablayoutviewpager

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.viewpager.widget.ViewPager
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayout.OnTabSelectedListener
import com.google.android.material.tabs.TabLayout.Tab


class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState : Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        var viewPager = findViewById<ViewPager>(R.id.pager)
        val tabLayout = findViewById<TabLayout>(R.id.tab_layout)
        //var adapter = PagerAdapter(this, supportFragmentManager)
        var adapter = PagerAdapter(supportFragmentManager)


        viewPager.adapter = adapter
        tabLayout.setupWithViewPager(viewPager)


        tabLayout.addOnTabSelectedListener(object : OnTabSelectedListener {
            override fun onTabSelected(tab : Tab) {
                Log.i("RC", "  onTabSelected() = " + tab.position)
                //viewPager.currentItem = tab.position
            }

            override fun onTabUnselected(tab : Tab) {
                Log.i("RC", "onTabUnselected() = " + tab.position)
            }

            override fun onTabReselected(tab : Tab) {
                Log.i("RC", "onTabReselected() = " + tab.position)
            }
        })

    }
}