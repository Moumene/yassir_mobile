package com.example.stage_part1;

import android.annotation.SuppressLint;
import android.app.AlarmManager;
import android.app.DatePickerDialog;
import android.app.Notification;
import android.app.PendingIntent;
import android.app.TimePickerDialog;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.SystemClock;
import android.provider.CalendarContract.*;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.design.widget.BottomSheetDialogFragment;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationManagerCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TimePicker;
import android.widget.Toast;

import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.Date;
import java.util.concurrent.TimeUnit;

import static android.content.Context.ALARM_SERVICE;
import static android.support.v4.content.ContextCompat.getSystemService;

public class BottomSheetDialog extends BottomSheetDialogFragment {
     private EditText dateedit;
     private EditText timeedit;

    private int year, month, day;
    private int hour, minute;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.bottom_sheet_layout,container,false);
        return v;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
         dateedit= (EditText) getView().findViewById(R.id.Dateedit);
        dateedit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                showDatePicker();
            }
        });
        timeedit= (EditText) getView().findViewById(R.id.Timeedit) ;
        timeedit.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                showTimePicker();
            }
        });

        Button add_btn = (Button) getView().findViewById(R.id.add_alarm_btn) ;
        add_btn.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                if ((timeedit.getText().toString()!="") && (dateedit.getText().toString()!="")){

                    Calendar c = Calendar.getInstance();
                    c.set(year,month,day,hour,minute);

                    if (!c.before(Calendar.getInstance())){
                        addNotif(year,month,day,hour,minute);


                        ImageButton imgbtn = ((resaDetails)getActivity()).alarmBtn;
                        imgbtn.setImageResource(R.drawable.alarm_icon_configured_white);

                        resaDetails.isAlarmConfigured = true;
                        dismiss();
                    }
                    else {
                        Toast toast = Toast.makeText(getActivity(),
                                "Veuillez entrer une date valide",
                                Toast.LENGTH_SHORT);

                        toast.show();
                    }
                }

            }
        });

    }

    private Calendar getSetTime(){

        String timeString = timeedit.getText().toString();
        String[] separatedTime = timeString.split(":");
        hour = Integer.parseInt(separatedTime[0]);
        minute = Integer.parseInt(separatedTime[1]);


        return  null;
    }


    private void addNotif(int year,int month, int day,int hour,int minute) {
        Date date = new Date();

        getSetTime();

        NotificationCompat.Builder builder = new NotificationCompat.Builder(getActivity(),"5")
                .setSmallIcon(R.drawable.ic_star_black_24dp)
                .setContentTitle("Rappel de Réservation")
                .setContentText("Vous avez un trajet entre Said Hamdin -kouba")
                .setStyle(new NotificationCompat.BigTextStyle()
                        .bigText("Vous avez un trajet entre Said Hamdin -kouba avec monsieur Moumen Moumen"))
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setAutoCancel(true);
        //Vibration
        builder.setVibrate(new long[] { 1000, 1000, 1000, 1000, 1000 });
        Intent intent = new Intent(getActivity(),resaDetails.class);
        PendingIntent activity = PendingIntent.getActivity(getActivity(),001,intent,PendingIntent.FLAG_CANCEL_CURRENT);
        builder.setContentIntent(activity);

        Notification notification = builder.build();

        Intent notificationIntent = new Intent(getActivity(), NotificationPublisher.class);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION_ID, 001);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION, notification);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(getActivity(), 001, notificationIntent, PendingIntent.FLAG_CANCEL_CURRENT);

        Calendar Current = Calendar.getInstance();

        Calendar calender = Calendar.getInstance();

        calender.set(year,month,day,hour,minute);

        //DEBUGGING
        Date i  = calender.getTime();
        Date j  = Current.getTime();


        long futureInMillis = calender.getTimeInMillis()-Current.getTimeInMillis();

        // SystemClock.elapsedRealtime() +10;
        AlarmManager alarmManager = (AlarmManager) getActivity().getSystemService(Context.ALARM_SERVICE);

        alarmManager.setExact(AlarmManager.RTC_WAKEUP,calender.getTimeInMillis(), pendingIntent);

    }


    private void showTimePicker() {
        TimePickerFragment time = new TimePickerFragment();
        Calendar calender = Calendar.getInstance();
        Bundle args = new Bundle();
        args.putInt("hour", calender.get(Calendar.HOUR));
        args.putInt("minute", calender.get(Calendar.MINUTE));
        time.setArguments(args);
        /**
         * Set Call back to capture selected date
         */
        time.setCallBack(ontime);
       time.show(getFragmentManager(), "Time Picker");
    }

    TimePickerDialog.OnTimeSetListener ontime = new TimePickerDialog.OnTimeSetListener() {
        @Override
        public void onTimeSet(TimePicker view, int hourOfDay, int minutee) {
            timeedit.setText(String.valueOf(hourOfDay)+":"+String.valueOf(minutee));
            hour = hourOfDay;
            minute = minutee;
        }
    };
    private void showDatePicker() {
        DatePickerFragment date = new DatePickerFragment();
        /**
         * Set Up Current Date Into dialog
         */

        Calendar calender = Calendar.getInstance();
        Bundle args = new Bundle();
        args.putInt("year", calender.get(Calendar.YEAR));
        args.putInt("month", calender.get(Calendar.MONTH));
        args.putInt("day", calender.get(Calendar.DAY_OF_MONTH));
        date.setArguments(args);
        /**
         * Set Call back to capture selected date
         */
        date.setCallBack(ondate);
        date.show(getFragmentManager(), "Date Picker");
    }

    DatePickerDialog.OnDateSetListener ondate = new DatePickerDialog.OnDateSetListener() {

        public void onDateSet(DatePicker view, int yearr, int monthOfYear,
                              int dayOfMonth) {

           dateedit.setText(String.valueOf(dayOfMonth) + "/" + String.valueOf(monthOfYear+1)
                    + "/" + String.valueOf(yearr));

           year = yearr;
           month = monthOfYear;
           day = dayOfMonth;
        }
    };




}
