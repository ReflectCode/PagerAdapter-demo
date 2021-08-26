<h1 align="center">
  <a href="http://www.reflectcode.com">
    ReflectCode
  </a>
</h1>
<p align="center">
  <strong>Automated Source Code Transformation service</strong><br>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green" alt="Platform - Android | iOS" />
 
  <a href="https://twitter.com/intent/follow?screen_name=reflectcode">
    <img src="https://img.shields.io/twitter/follow/reflectcode.svg?label=Follow%20@reflectcode" alt="Follow @reflectcode" />
  </a>
  
</p>


-----
# PagerAdapter demo
This demo app is developed in Kotlin. 
It helps user to navigate through multiple pages using left and right direction swipe gesture.
User can also tap on tab button to directly jump to the page.

## Credits
	iOS Lib : https://github.com/Yalantis/Segmentio
	
## Dev Notes

* Android : Kotlin
* iOS : Swift 5.0
	
### Android classes ported -
* androidx.viewpager.widget.ViewPager
* com.google.android.material.tabs.TabLayout
* com.google.android.material.tabs.TabLayout.Tab
* com.google.android.material.tabs.TabLayout.OnTabSelectedListener

* androidx.fragment.app.Fragment
* androidx.fragment.app.FragmentManager
* androidx.fragment.app.FragmentPagerAdapter

* android.os.Bundle
* android.view.View
* android.view.ViewGroup
* android.view.LayoutInflater
* androidx.fragment.app.Fragment


### Details of layout controls ported -
* TextView
* RelativeLayout
* androidx.viewpager.widget.ViewPager
* com.google.android.material.tabs.TabLayout

### iOS classes used -
* UIViewController
* UIPageViewController 
* UIPageViewControllerDataSource 
* UIPageViewControllerDelegate
* RCPageViewControllerHelper 
* UIPageControl
* Segmentio, SegmentioItem

-----

## Screen shots

Screen shot of Android and iOS devices - 
<img src="/Visuals/android-1.png" alt="Android Screenshot"/>
<img src="/Visuals/iPhone 8Plus (iOS14.5).png" alt="iOS Screenshot"/>

-----

## License

This project is made available under the MIT license. See the LICENSE file for more details.