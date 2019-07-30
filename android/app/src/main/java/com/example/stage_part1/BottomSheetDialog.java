package com.example.stage_part1;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.net.Uri;
import android.os.Bundle;
import android.provider.CalendarContract.*;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.design.widget.BottomSheetDialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TimePicker;

import java.util.Calendar;

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


                    year =2019;
                    month=8;
                    day=20;
                    hour=14;
                    minute=20;
                    addAlarmEvent(year,month,day,hour,minute);


                    ImageButton imgbtn = ((resaDetails)getActivity()).alarmBtn;
                    imgbtn.setImageResource(R.drawable.alarm_icon_configured_white);

                    resaDetails.isAlarmConfigured = true;
                    dismiss();
                }

            }
        });

    }

    private void addAlarmEvent(int year,int month, int day,int hour,int minute) {
        long calID = 3;
        long startMillis = 0;
        long endMillis = 0;
        Calendar beginTime = Calendar.getInstance();
        beginTime.set(year, month, day, hour, minute);
        startMillis = beginTime.getTimeInMillis();
        Calendar endTime = Calendar.getInstance();
        endTime.set(year, month, day, hour, minute+10);
        endMillis = endTime.getTimeInMillis();



        ContentResolver cr =  resaDetails.getContextApp().getContentResolver();
        ContentValues values = new ContentValues();
        values.put(Events.DTSTART, startMillis);
        values.put(Events.DTEND, endMillis);
        values.put(Events.TITLE, "Trip");
        values.put(Events.DESCRIPTION, "Trip to bouismail");
        values.put(Events.CALENDAR_ID, calID);
        Uri uri = cr.insert(Events.CONTENT_URI, values);

        //long eventID = Long.parseLong(uri.getLastPathSegment());
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
        public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
            timeedit.setText(String.valueOf(hourOfDay)+":"+String.valueOf(minute));
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

        public void onDateSet(DatePicker view, int year, int monthOfYear,
                              int dayOfMonth) {

           dateedit.setText(String.valueOf(dayOfMonth) + "/" + String.valueOf(monthOfYear+1)
                    + "/" + String.valueOf(year));
        }
    };




}
