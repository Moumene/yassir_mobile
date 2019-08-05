package com.example.stage_part1;

import android.app.Notification ;
import android.app.NotificationChannel ;
import android.app.NotificationManager ;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.BroadcastReceiver ;
import android.content.Context ;
import android.content.Intent ;
import android.os.Build;
import android.support.v4.app.NotificationCompat;

import static android.app.NotificationManager.IMPORTANCE_DEFAULT;

public class NotificationPublisher extends BroadcastReceiver {

    private static final String CHANNEL_ID = "com.singhajit.notificationDemo.channelId";


    public static String NOTIFICATION_ID = "NOTIFICATION_ID";
    public static String NOTIFICATION = "NOTIFICATION";

    @Override
    public void onReceive(final Context context, Intent intent) {

        Intent notificationIntent = new Intent(context, resaDetails.class);

        TaskStackBuilder stackBuilder = TaskStackBuilder.create(context);
        stackBuilder.addNextIntentWithParentStack(notificationIntent);
       // stackBuilder.addNextIntent(notificationIntent);

        PendingIntent pendingIntent = stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT);


        Notification.Builder builder = new Notification.Builder(context);
        builder.setContentIntent(pendingIntent);
        Notification notification = builder
                .setSmallIcon(R.drawable.ic_star_black_24dp)
                .setContentTitle("Rappel de Réservation")
                .setContentText("Vous avez un trajet entre Said Hamdin -kouba")
                .setStyle(new Notification.BigTextStyle()
                        .bigText("Vous avez un trajet entre Said Hamdin -kouba avec monsieur Moumen Moumen"))
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setAutoCancel(true)
                .setVibrate(new long[] { 1000, 1000, 1000, 1000, 1000 })
                .build();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            builder.setChannelId(CHANNEL_ID);
        }

        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    CHANNEL_ID,
                    "NotificationDemo",
                    IMPORTANCE_DEFAULT
            );
            notificationManager.createNotificationChannel(channel);
        }

        notificationManager.notify(0, notification);

    }
}