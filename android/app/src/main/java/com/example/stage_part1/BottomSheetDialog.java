package com.example.stage_part1;


import android.app.AlarmManager;
import android.app.DatePickerDialog;
import android.app.Notification;
import android.app.PendingIntent;
import android.app.TimePickerDialog;

import android.content.Context;
import android.content.Intent;

import android.databinding.DataBindingUtil;
import android.os.Bundle;

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.design.widget.BottomSheetDialogFragment;
import android.support.v4.app.NotificationCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.example.stage_part1.databinding.BottomSheetLayoutBinding;

import java.util.Calendar;
import java.util.Date;

public class BottomSheetDialog extends BottomSheetDialogFragment {
     private EditText dateedit;
     private EditText timeedit;
     private BottomSheetLayoutBinding binding ;
    private int year, month, day;
    private int hour, minute;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

      binding = DataBindingUtil.inflate(inflater,R.layout.bottom_sheet_layout,container,false);
      binding.setBSD(this);
      binding.setDate("    ");
      binding.setTime("    ");
      return binding.getRoot();
    }

    public void onClickAddBtn(View v) {
        if ((binding.Timeedit.getText().toString()!="") && (binding.Dateedit.getText().toString()!="")){

            Calendar c = Calendar.getInstance();
            c.set(year,month,day,hour,minute);

            if (!c.before(Calendar.getInstance())){
                addNotif(year,month,day,hour,minute);


                ImageButton imgbtn = ((resaDetails)getActivity()).alarmBtn;
                imgbtn.setImageResource(R.drawable.alarm_configured_fixed);
                imgbtn.setScaleType(ImageView.ScaleType.CENTER);
                resaDetails.isAlarmConfigured = true;
                resaDetails.SaveAlarmConfig();
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


    public void onClickDate(View v){
        showDatePicker();

    }
    public void onClickTime(View v){
        showTimePicker();

    }



    private void addNotif(int year,int month, int day,int hour,int minute) {

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

        alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,calender.getTimeInMillis(), pendingIntent);

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
//            timeedit.setText(String.valueOf(hourOfDay)+":"+String.valueOf(minutee));
            hour = hourOfDay;
            minute = minutee;
            binding.setTime(hourOfDay+":"+minutee);
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

          // dateedit.setText(String.valueOf(dayOfMonth) + "/" + String.valueOf(monthOfYear+1)
          //          + "/" + String.valueOf(yearr));

           binding.setDate(String.valueOf(dayOfMonth)+"/"+String.valueOf(monthOfYear)+"/"+String.valueOf(yearr));
        //   binding.setMonth(String.valueOf(monthOfYear));
        //   binding.setYear(String.valueOf(yearr));

           year = yearr;
           month = monthOfYear;
           day = dayOfMonth;
        }
    };




}
