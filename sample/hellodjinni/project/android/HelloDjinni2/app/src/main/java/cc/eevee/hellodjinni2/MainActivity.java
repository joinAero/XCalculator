package cc.eevee.hellodjinni2;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ScrollView;
import android.widget.TextView;

import cc.eevee.hellodjinni.HelloDjinni;

public class MainActivity extends AppCompatActivity {

    private TextView mTextView;
    private ScrollView mScrollView;

    private HelloDjinni mHelloDjinniInterface = HelloDjinni.create();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mTextView = (TextView) findViewById(R.id.textView);
        mScrollView = (ScrollView) findViewById(R.id.scrollView);
    }

    public void onButtonClick(View view) {
        mTextView.append(mHelloDjinniInterface.getHelloDjinni() + "\n");
        mScrollView.fullScroll(ScrollView.FOCUS_DOWN);
    }
}
