package com.example.stage_part1.util;

import java.util.Calendar;

public class StringUtil {

    public static String getDateString(Calendar dateheureTrip){
        int dayOfMonth = dateheureTrip.get(Calendar.DAY_OF_MONTH);
        int monthOfYear = dateheureTrip.get(Calendar.MONTH);
        int yearr = dateheureTrip.get(Calendar.YEAR);
        return String.valueOf(dayOfMonth) + "/" + String.valueOf(monthOfYear)
                + "/" + String.valueOf(yearr);
    }

    public static String getTimeString(Calendar dateheureTrip){
        int hour= dateheureTrip.get(Calendar.HOUR);
        int minute = dateheureTrip.get(Calendar.MINUTE);
        return String.valueOf(hour) + ":" + String.valueOf(minute);
    }


}
