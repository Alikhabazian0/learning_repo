//+------------------------------------------------------------------+
//|                                    artificial neural network.mq5 |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//--- Include Some files
#include <Trade\Trade.mqh>         //--- Including Library for Executing All Trades
#include <Trade\PositionInfo.mqh>  //--- Including Library for Obtaining Information on positions

//--- Definition Of Weights
input double w0 = -0.7 ;
input double w1 = 0.1  ;
input double w2 = 0.3  ;
input double w3 = 0.5  ;
input double w4 = -1   ;
input double w5 = -0.4 ;
input double w6 = 0.2  ;
input double w7 = 0.4  ;
input double w8 = -0.2 ;
input double w9 = 0.4  ;

int     iRSI_handle          ; //--- Variable for Storing Indicator Handle
double  iRSI_buf[]           ; //--- Dynamic Array for Storing Indicator Value

double  inputs[10]           ; //--- Array for Storing Inputs
double  weight[10]           ; //--- Array for Storing Weights

double  out                  ; //--- Variable for Storing the Output of a Neuron

string  my_symbol            ; //--- Variable for Storing the Symbol
ENUM_TIMEFRAMES my_timeframe ; //--- Variable for Storing the Time Frame
double  lot_size             ; //--- Variable for Storing Minimum Lot Size of Trade

CTrade   m_Trade             ; //--- Object for Execution of Trades Library
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
lot_size = SymbolInfoDouble(my_symbol,SYMBOL_VOLUME_MIN);

//---Apply the RSI Indicator
iRSI_handle = iRSI(my_symbol,my_timeframe,14,PRICE_CLOSE);

if(iRSI_handle==INVALID_HANDLE)
  {
   //---No Handle Obtained
   Print(" Failed to Access the Indicator Handle");
   return(-1);
  }   
//---Add the indicator to the price chart
ChartIndicatorAdd(ChartID(),0,iRSI_handle);

//---Set the iRSI_buf array indexing as time series
ArraySetAsSeries(iRSI_buf,true);

//---Place weights into the array
weight[0] = w0 ;
weight[1] = w1 ;
weight[2] = w2 ;
weight[3] = w3 ;
weight[4] = w4 ;
weight[5] = w5 ;
weight[6] = w6 ;
weight[7] = w7 ;
weight[8] = w8 ;
weight[9] = w9 ;

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---Delete of Indicator Handle
 IndicatorRelease(iRSI_handle);
//---Free the RSI_buf Dynamic Array of Data
ArrayFree(iRSI_buf) ; 
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---Variable for checking result of calculation on buffer
 int error = 0 ;
//---Copy data from the indicator array to buffer
error = CopyBuffer(iRSI_handle,0,1,10,iRSI_buf);
//---Controlling of Buffer Feed
if(error<0)
  {
   Print("Failed to copy data from The indicator buffer");
   return;
  }
//---Normalization of input Parameters
 double d1 = 0.0 ;
 double d2 = 1.0 ;
 double x_min = iRSI_buf[ArrayMinimum(iRSI_buf)];  
 double x_max = iRSI_buf[ArrayMaximum(iRSI_buf)];  
 //---Defintion of Loop for normalizing of input data
 for(int i=0;i<ArraySize(inputs);i++)
  inputs[i] = (((iRSI_buf[i]-x_min)*(d2-d1))/(x_max-x_min))+ d1 ;

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
 
 //--- Sigmoid Function Definition
 Out = 1/(1+exp(-x));
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
 NET *= 0.4 ;
 return(ActivateNeuron(NET));
 //---Send the weighted sum inputs to the activation function and return its values
}