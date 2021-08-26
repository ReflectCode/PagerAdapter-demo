package com.rc.demo.tablayoutviewpager

import android.content.Context
import  androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter

class PagerAdapter(fm : FragmentManager) : FragmentPagerAdapter(fm) {

    var mNumOfTabs = 3

    fun PagerAdapter(fm : FragmentManager?, NumOfTabs : Int) {
        mNumOfTabs = NumOfTabs
    }

    override fun getPageTitle(position : Int) : CharSequence? {
        return "Tab-" + position
    }

    override fun getItem(position : Int) : Fragment {
        return when(position) {
            0 -> {
                tab1Page()
            }
            1 -> {
                tab2Page()
            }
            2 -> {
                tab3Page()
            }
            else -> tab3Page()
        }
    }

    override fun getCount() : Int {
        return mNumOfTabs
    }

}