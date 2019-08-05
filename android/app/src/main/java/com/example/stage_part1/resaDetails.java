package com.example.stage_part1;


import android.app.AlarmManager;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.PendingIntent;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.databinding.DataBindingUtil;
import android.net.Uri;
import android.preference.PreferenceManager;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.graphics.drawable.DrawerArrowDrawable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.support.v7.widget.Toolbar;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Toast;

import com.example.stage_part1.databinding.ActionBarBinding;
import com.example.stage_part1.databinding.ActivityResaDetailsBinding;
import com.example.stage_part1.databinding.AlertPromtBinding;
import com.example.stage_part1.model.Passager;
import com.example.stage_part1.model.Trip;

import com.example.stage_part1.databinding.BottomSheetLayoutBinding;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class resaDetails extends AppCompatActivity {

    public static Context contextApp;

    public ImageButton alarmBtn;
    public static boolean isAlarmConfigured = false;

    //data binding
    ActivityResaDetailsBinding mBinding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        contextApp = getApplicationContext();

        //Binding stuff
        mBinding = DataBindingUtil.setContentView(this,R.layout.activity_resa_details);

        Passager moumene = new Passager("Moumen","Moumen",4.5f,R.mipmap.pic,"0551573525");
        mBinding.setPassager(moumene);


        Calendar dateheureTrip = Calendar.getInstance();
        dateheureTrip.set(2018,11,12,19,30);

        mBinding.setTrip(new Trip(moumene,dateheureTrip,"Said Hamdine","Chemin de Yassir, Bir Mourad Rais","Kouba","Kouba",2000,"X321EQVC1"));


        //toolbar settings

       // aBinding= DataBindingUtil.setContentView(this,R.layout.action_bar);
        mBinding.actionBar.actionbarr.setTitle("Détails de la Réservation");
        setSupportActionBar( mBinding.actionBar.actionbarr);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowHomeEnabled(true);

        //Alarm Button init
        alarmBtn = findViewById(R.id.bell_btn);
            isAlarmConfigured = IsAalrmSet();
            SaveAlarmConfig();

        if (isAlarmConfigured)
            alarmBtn.setImageResource(R.drawable.alarm_configured_fixed);

    }


    public static Context getContextApp(){
        return contextApp;
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

    public static void SaveAlarmConfig(){
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(contextApp);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putInt("NOTIF_ID", 001);
        editor.putBoolean("IS_ALARM_CONFIGURED",isAlarmConfigured);
        editor.commit();
    }
    public static void LoadAlarmConfig(){
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(contextApp);
        isAlarmConfigured = sharedPreferences.getBoolean("IS_ALARM_CONFIGURED", false);
        System.out.println("\n"+isAlarmConfigured+"\n");
    }

    public void Onclick_alarm(View v) {

        if (!isAlarmConfigured) {//Bottom sheet ajouter alarme

            BottomSheetLayoutBinding binding = DataBindingUtil
                    .inflate(LayoutInflater.from(this), R.layout.bottom_sheet_layout, null, false);
            BottomSheetDialog bottomSheet = new BottomSheetDialog();

            bottomSheet.show(getSupportFragmentManager(), "BottomSheet");

        } else {//Popup supprimer notif

            AlertPromtBinding alertPromtBinding = DataBindingUtil
                    .inflate(LayoutInflater.from(this),R.layout.alert_promt,null,false);
//            LayoutInflater layoutInflater = LayoutInflater.from(this);
//            View promptView = layoutInflater.inflate(R.layout.alert_promt, null);

            final AlertDialog.Builder alertDBuilder = new AlertDialog.Builder(this);
            final AlertDialog alertD = alertDBuilder.create();

           //Button btn_cancel_supp_alarm = (Button) promptView.findViewById(R.id.btn_cancel_supp_alarm);

            alertPromtBinding.btnSuppAlarm.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    CancelAlarm();
                    ImageButton imgbtn = findViewById(R.id.bell_btn);
                    imgbtn.setImageResource(R.drawable.baseline_notifications_white_24dp);
                    isAlarmConfigured = false;
                    SaveAlarmConfig();
                    alertD.cancel();

                }
            });

           alertPromtBinding.btnCancelSuppAlarm.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    alertD.cancel();
                }
            });

            alertD.setView(alertPromtBinding.getRoot());

            alertD.show();

        }

    }
    public void location_btn_1_click(View v)
    {
        String source ="My+Location";
        String destination = mBinding.getTrip().getSourceAdr();
        Uri gmmIntentUri = Uri.parse("https://www.google.com/maps/dir/?api=1&origin="+ source + "&destination="+destination+"&travelmode=car");
        Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
        mapIntent.setPackage("com.google.android.apps.maps");
        startActivity(mapIntent);
    }

    public void location_btn_2_click(View v)
    {
        String source = "My+Location";
        String destination = mBinding.getTrip().getDestinationAdr();
        Uri gmmIntentUri = Uri.parse("https://www.google.com/maps/dir/?api=1&origin="+ source + "&destination="+destination+"&travelmode=car");
        Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
        mapIntent.setPackage("com.google.android.apps.maps");
        startActivity(mapIntent);
    }

    public void onClickCall(View v)
    {
        Intent callIntent = new Intent(Intent.ACTION_DIAL);
        callIntent.setData(Uri.parse("tel:"+mBinding.getPassager().getNumTel()));
        startActivity(callIntent);
    }

    public void CancelAlarm(){
        AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        Intent myIntent = new Intent(getApplicationContext(), NotificationPublisher.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(
                getApplicationContext(), 001, myIntent,
                PendingIntent.FLAG_UPDATE_CURRENT);
        alarmManager.cancel(pendingIntent);
    }

    public boolean IsAalrmSet() {

        Intent notificationIntent = new Intent(getApplicationContext(), NotificationPublisher.class);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION_ID, 001);
        Intent myIntent = new Intent(getApplicationContext(), NotificationPublisher.class);

        boolean alarmUp =  (PendingIntent.getBroadcast(  getApplicationContext(), 001, myIntent,
                PendingIntent.FLAG_NO_CREATE)!=null);
        if (alarmUp) {
            Log.d("Alarm" ,"set");
        }
        else    Log.d("Alarm" ,"not set");

        return alarmUp;
    }

}
