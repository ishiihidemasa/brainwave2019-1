public class BrainWave {
  long t_start;
  int top_idx;
  float[] average;
  
  final int PORT = 5000;
  OscP5 oscP5 = new OscP5(this, PORT);
  
  final int N_CHANNELS = 4;
  final int N_MUSIC = 50;
  final int TIME_SPAN = 90;
  float[] sum = new float[N_MUSIC];  // チャンネルごとの総和
  int count = 0;
  float[] avg_tmp = new float[N_MUSIC];  // チャンネルごとの平均値を格納
  float[] avg_of_Nch = new float[N_MUSIC];  // サンプルごとの4チャンネルの平均値
  int mu_idx=0;
  float min_avg = pow(10, 10);
  int min_idx;
  
  int duration = 90;  // 1サンプル当たりの再生時間[s]，初期設定90秒
  
  void setStart(long time) {
    t_start = time;
  }
  
  int getTopidx() {
    // return index
    return min_idx;    
  }
  
  void calc(int duration) { // calculate avg for each music every duration[s]
    float t = (millis() - t_start) / 1000.0;
    
    if(t-duration*mu_idx > duration){   //every duration[s] 

      for(int ch = 0; ch < N_CHANNELS; ch++){
        avg_tmp[ch] = sum[ch] / count;
        sum[ch] = 0; //reset sum[ch]
      }
      
      for(int ch = 0; ch < N_CHANNELS; ch++){
        avg_of_Nch[mu_idx] += avg_tmp[ch];
        avg_tmp[ch] = 0; //reset avg_tmp
      }
      
      avg_of_Nch[mu_idx] = avg_of_Nch[mu_idx] / N_CHANNELS;
      
      if(avg_of_Nch[mu_idx] < min_avg){
        min_avg = avg_of_Nch[mu_idx];
        min_idx = mu_idx;
      }
      
      mu_idx += 1;
      count = 0;
      
    }
    
  }
  
  void oscEvent(OscMessage msg){
  // add data to sum 
  float data;
  if(msg.checkAddrPattern("/muse/eeg")){
    count += 1;
    for(int ch = 0; ch < N_CHANNELS; ch++){
      data = msg.get(ch).floatValue();
      sum[ch] += data;
    }
  }    
  }
}
