package com.example.stage_part1.util;

import com.example.stage_part1.model.Trip;

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

    public static String getSurnameName(Trip trip){
        String name = trip.getPassager().getName();
        String surname = trip.getPassager().getSurname();
        return surname + " "  + name;
    }

    public static String getMoneyFormat(long montant){
        return Long.toString(montant) + "Da";
    }

}
