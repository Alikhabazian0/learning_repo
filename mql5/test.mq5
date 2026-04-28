//+------------------------------------------------------------------+
//|                                                         test.mq5 |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Definition of Inputs Parameters Layer
double x[] ;
double w[] ;
double NET ;
x[0]= 0.1 ; // Set the Input Value of x1
x[1]= 0.7 ; // Set the Input Value of x2
x[2]= 0.9 ; // Set the Input Value of x3

w[0]= 0.4 ; // Set the weight Value of w1
w[1]= 0.3 ; // Set the weight Value of w2
w[2]= 0.7 ; // Set the weight Value of w3

for(int i=0;i<3;i++)
  {
   NET+= x[i]*w[i] ; // Adding The Weighted net input values together
  }
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
double out ;
if NET>=x) out = 1;
else
    out = 0 ;

//--- Sigmoid Function
 Out = 1/(1+exp(-NET));

//--- Tangant Function
 Out = (exp(NET)-exp(-NET))/(exp(NET)+exp(-NET));    
   
  }
//+------------------------------------------------------------------+
