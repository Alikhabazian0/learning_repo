//+------------------------------------------------------------------+
//|                                                  ann_on_macd.mq5 |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "faradars"
#property link      "https://faradars.org/"
#property version   "1.00"

//--- Include Some files
#include <Trade\Trade.mqh>         //--- Including the Library for Executing All Trades
#include <Trade\PositionInfo.mqh>  //--- Including The Library for Obtaining Information on positions

//--- Definition Of Weights
input double w0 = 0.5 ;
input double w1 = 0.5 ;
input double w2 = 0.5 ;
input double w3 = 0.5 ;
input double w4 = 0.5 ;
input double w5 = 0.5 ;
input double w6 = 0.5 ;
input double w7 = 0.5 ;
input double w8 = 0.5 ;
input double w9 = 0.5 ;
input double w10 = 0.5 ;
input double w11 = 0.5 ;
input double w12 = 0.5 ;
input double w13 = 0.5 ;
input double w14 = 0.5 ;
input double w15 = 0.5 ;
input double w16 = 0.5 ;
input double w17 = 0.5 ;
input double w18 = 0.5 ;
input double w19 = 0.5 ;


int     iMACD_handle          ; //--- Variable for Storing Indicator Handle
double  iMACD_mainbuf[]       ; //--- Dynamic Array for Storing Indicator (MAin) Value
double  iMACD_signalbuf[]     ; //--- Dynamic Array for Storing Indicator (Signal) Value

double  inputs[20]           ; //--- Array for Storing Inputs
double  weight[20]           ; //--- Array for Storing Weights

double  out                  ; //--- Variable for Storing the Output of a Neuron

string  my_symbol            ; //--- Variable for Storing the Symbol
ENUM_TIMEFRAMES my_timeframe ; //--- Variable for Storing the Time Frame
double  lot_size             ; //--- Variable for Storing Minimum Lot Size of Trade

CTrade        m_Trade        ; //--- Object for Execution of Trades Library
CPositionInfo m_Position     ; //--- Object for Execution of Information of Positions

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---Definition of Symbol
 my_symbol = Symbol();

//---Definition of Time Frame
my_timeframe = PERIOD_CURRENT;

//---Definition of Minimum Lot Size
//--lot_size = SymbolInfoDouble(my_symbol,SYMBOL_VOLUME_MIN);
lot_size = 1.0 ;

//---Apply the MACD Indicator
iMACD_handle = iMACD(my_symbol,my_timeframe,12,26,9,PRICE_CLOSE);

if(iMACD_handle==INVALID_HANDLE)
  {
   //---No Handle Obtained
   Print(" Failed to Access the Indicator Handle");
   return(-1);
  }   
//---Add the indicator to the price chart
ChartIndicatorAdd(ChartID(),0,iMACD_handle);

//---Set the iMACD_buf array indexing as time series
ArraySetAsSeries(iMACD_mainbuf,true);
ArraySetAsSeries(iMACD_signalbuf,true);

//---Place weights into the array
weight[0]  =  w0 ;
weight[1]  =  w1 ;
weight[2]  =  w2 ;
weight[3]  =  w3 ;
weight[4]  =  w4 ;
weight[5]  =  w5 ;
weight[6]  =  w6 ;
weight[7]  =  w7 ;
weight[8]  =  w8 ;
weight[9]  =  w9 ;
weight[10] = w10 ;
weight[11] = w11 ;
weight[12] = w12 ;
weight[13] = w13 ;
weight[14] = w14 ;
weight[15] = w15 ;
weight[16] = w16 ;
weight[17] = w17 ;
weight[18] = w18 ;
weight[19] = w19 ;

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---Delete of Indicator Handle
 IndicatorRelease(iMACD_handle);
//---Free the MACD_buf Dynamic Array of Data
ArrayFree(iMACD_mainbuf) ; 
ArrayFree(iMACD_signalbuf) ; 
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---Variable for checking result of calculation on buffers
 int error1 = 0 ;
 int error2 = 0 ;
 
//---Copy data from the indicator array to buffer
error1 = CopyBuffer(iMACD_handle,0,2,ArraySize(inputs)/2,iMACD_mainbuf);
error2 = CopyBuffer(iMACD_handle,1,2,ArraySize(inputs)/2,iMACD_signalbuf);

//---Controlling of Buffers Feed
if(error1<0 || error2<0)
  {
   Print("Failed to copy data from The indicator buffer");
   return;
  }
//---Normalization of input Parameters
 double d1 = -1.0 ;
 double d2 =  1.0 ;
 double x_min = MathMin(iMACD_mainbuf[ArrayMinimum(iMACD_mainbuf)],iMACD_signalbuf[ArrayMinimum(iMACD_signalbuf)]);  
 double x_max = MathMax(iMACD_mainbuf[ArrayMaximum(iMACD_mainbuf)],iMACD_signalbuf[ArrayMaximum(iMACD_signalbuf)]);   
 //---Defintion of Loop for normalizing of input data
 for(int i=0;i<ArraySize(inputs)/2;i++)
 {
  inputs[i*2] = (((iMACD_mainbuf[i]-x_min)*(d2-d1))/(x_max-x_min))+ d1 ;
  inputs[i*2+1] = (((iMACD_signalbuf[i]-x_min)*(d2-d1))/(x_max-x_min))+ d1 ;
 }
//---Definition of Trading(Set Positions)
//---Define of Buy Position  
 if(out<0.5)
   {
    //---if the position for this symbol already exists
    if(m_Position.Select(my_symbol))
      {
       //---and this is the sell position , then close it
       if(m_Position.PositionType()==POSITION_TYPE_SELL)
         m_Trade.PositionClose(my_symbol);
      
       if(m_Position.PositionType()==POSITION_TYPE_BUY)
         return;
      }
    m_Trade.Buy(lot_size,my_symbol) ; 
   } 
//---Define of Sell Position  
 if(out>=0.5)
   {
    //---if the position for this symbol already exists
    if(m_Position.Select(my_symbol))
      {
       //---and this is the buy position , then close it
       if(m_Position.PositionType()==POSITION_TYPE_BUY)
         m_Trade.PositionClose(my_symbol);
      
       if(m_Position.PositionType()==POSITION_TYPE_SELL)
         return;
      }
    m_Trade.Sell(lot_size,my_symbol) ; 
   }      
  }
//+------------------------------------------------------------------+
//|  Activation Function                                             |
//+------------------------------------------------------------------+
double ActivateNeuron(double x)
{
 //---Variable Definition for Activation Function Result
 double Out;
 
 //--- Hyberbolic Tangant Function Definition
 Out = (exp(x)-exp(-x))/(exp(x)+exp(-x));
 //---Return the Activation Function
 return(Out);
}
//+------------------------------------------------------------------+
//|   Neuron Calculation of Input summation                          |
//+------------------------------------------------------------------+
double CalculateInputSummation(double &x[], double &w[])
{
 //---Defintion of variable for mutiplication of X(input) and W(weight)
 double NET = 0.0 ;
 
 //---Defintion of Loop 
 for(int i=0;i<ArraySize(x);i++)
   NET+=x[i]*w[i] ;
 //---Multiply The Net By Additional coeficient
 NET *= 0.1 ;
 return(ActivateNeuron(NET));
 //---Send the weighted sum inputs to the activation function and return its values
}