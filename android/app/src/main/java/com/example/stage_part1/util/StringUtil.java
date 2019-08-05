package com.example.stage_part1.util;

import com.example.stage_part1.model.Trip;

import java.util.Calendar;

public class StringUtil {

    public static String getDateStringSlash(Calendar dateheureTrip){
        int dayOfMonth = dateheureTrip.get(Calendar.DAY_OF_MONTH);
        int monthOfYear = dateheureTrip.get(Calendar.MONTH);
        int yearr = dateheureTrip.get(Calendar.YEAR);
        return String.valueOf(dayOfMonth) + "/" + String.valueOf(monthOfYear)
                + "/" + String.valueOf(yearr);
    }

    public static String getTimeString(Calendar dateheureTrip){
        int hour= dateheureTrip.get(Calendar.HOUR_OF_DAY);
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

    public static String getDateWords(Calendar dateHeure) {
        int year = dateHeure.get(Calendar.YEAR);
        int month = dateHeure.get(Calendar.MONTH);
        int day = dateHeure.get(Calendar.DAY_OF_MONTH);
        String res, sMonth;
        switch (month){
            case 1:
                sMonth = "Janvier";
                break;
            case 2:
                sMonth = "Fevrier";
                break;
            case 3:
                sMonth = "Mars";
                break;
            case 4:
                sMonth = "Avril";
                break;
            case 5:
                sMonth = "Mai";
                break;
            case 6:
                sMonth = "Juin";
                break;
            case 7:
                sMonth = "Juillet";
                break;
            case 8:
                sMonth = "Aout";
                break;
            case 9:
                sMonth = "Septembre";
                break;
            case 10:
                sMonth = "Octobre";
                break;
            case 11:
                sMonth = "Novembre";
                break;
            case 12:
                sMonth = "Decembre";
                break;
            default:
                sMonth = "NAN";
                break;
        }
        return Integer.toString(day) + " " + sMonth + " " + Integer.toString(year);
    }

}
