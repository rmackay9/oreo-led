    Wire.beginTransmission(SLA1);
    Wire.write(PATTERN_PARAMUPDATE);
    Wire.write(PARAM_BIAS_RED);  
    Wire.write(0);   
    Wire.write(PARAM_AMPLITUDE_RED);  
    Wire.write(100); 
    Wire.write(PARAM_BIAS_GREEN);
    Wire.write(0);
    Wire.write(PARAM_AMPLITUDE_GREEN);
    Wire.write(100);
    Wire.write(PARAM_BIAS_BLUE); 
    Wire.write(0);
    Wire.write(PARAM_AMPLITUDE_BLUE); 
    Wire.write(100);
    Wire.write(PARAM_PHASEOFFSET); 
    Wire.write(0);
    Wire.write(0); 
    Wire.write(PARAM_PERIOD); 
    Wire.write(2000>>8);
    Wire.write(2000); 
    Wire.endTransmission();   
    delay(2500);
    
    Wire.beginTransmission(SLA1);
    Wire.write(PATTERN_FADEIN);
    Wire.endTransmission();   
    delay(5000);
    
    Wire.beginTransmission(SLA1);
    Wire.write(PATTERN_SINE);
    Wire.write(PARAM_BIAS_RED);  
    Wire.write(100);  
    Wire.write(PARAM_BIAS_GREEN);
    Wire.write(100);
    Wire.write(PARAM_BIAS_BLUE); 
    Wire.write(100);
    Wire.write(PARAM_REPEAT); 
    Wire.write(1);
    Wire.endTransmission();
    delay(8000);
       
    Wire.beginTransmission(SLA1);
    Wire.write(PATTERN_FADEOUT);
    Wire.write(PARAM_BIAS_RED);  
    Wire.write(0);  
    Wire.write(PARAM_BIAS_GREEN);
    Wire.write(0);
    Wire.write(PARAM_BIAS_BLUE); 
    Wire.write(0);
    Wire.endTransmission();   
    
    // set loop time
    delay(5000);

void phaseSync() {
  
    Wire.beginTransmission(0x00);
    Wire.endTransmission();
    delay(50);
    
}

void stopCycle() {
    Wire.beginTransmission(SLA1);
    Wire.write(PATTERN_PARAMUPDATE);
    Wire.write(PARAM_REPEAT); 
    Wire.write(1);
    Wire.endTransmission();   
}


    Wire.write(PARAM_PERIOD); 
    Wire.write(period>>8);
    Wire.write(period); 

    Wire.write(PARAM_PHASEOFFSET); 
    Wire.write(phase>>8);
    Wire.write(phase); 
    
    Wire.write(PARAM_BIAS_RED);  
    Wire.write(100);   
    Wire.write(PARAM_AMPLITUDE_RED);  
    Wire.write(100); 
    
    Wire.write(PARAM_BIAS_GREEN);
    Wire.write(100);
    Wire.write(PARAM_AMPLITUDE_GREEN);
    Wire.write(100);
    
    Wire.write(PARAM_BIAS_BLUE); 
    Wire.write(100);
    Wire.write(PARAM_AMPLITUDE_BLUE); 
    Wire.write(100);
    