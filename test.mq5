//+------------------------------------------------------------------+
//|                                                         test.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
input double lot = 1;
input int stoplossPoint = 300;

//int OnInit()

 // {
//---
   
//---
  // return(INIT_SUCCEEDED);
 // }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
//void OnDeinit(const int reason)
 // {
//---
   
 // }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    MqlRates rates[];
    int Ema15 = iMA(Symbol(), PERIOD_CURRENT, 15, 1, MODE_EMA, 1);
    int rsi = iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE);
    double Close = iClose(Symbol(), PERIOD_CURRENT, 1);

    // Open Buy
    if (PositionsTotal() == 0)
    {
        if (Close > Ema15 && rsi > 30)
        {
            MqlTradeRequest request = {};
            MqlTradeResult result = {};

            // Set up the trade request parameters
            request.action = TRADE_ACTION_DEAL;
            request.symbol = Symbol() ;
            request.volume = lot;  // Set your desired lot size
            request.type = ORDER_TYPE_BUY;
            request.sl = 100;
            request.tp = 500; 
            request.price = SymbolInfoDouble(Symbol(), SYMBOL_BID); // Use BID price for buying
         
            // Send the buy order
            if (OrderSend(request, result))
            {
            
                Print("Buy order sent successfully. Ticket: ", result.retcode,result.deal,result.order);
            }
            else
            {
                Print("Error sending buy order. Error code: ", GetLastError());
            }
        }
        if (Close < Ema15 && rsi < 70)  // Adjust conditions for opening a sell order
    {
        MqlTradeRequest request = {};
        MqlTradeResult result = {};

        // Set up the trade request parameters
        request.action = TRADE_ACTION_DEAL;
        request.symbol = Symbol();
        request.volume = lot;  // Set your desired lot size
        request.type = ORDER_TYPE_SELL;
        request.sl = 100;
        request.tp = 500;  // Set to sell order
        request.price = SymbolInfoDouble(Symbol(), SYMBOL_ASK); // Use ASK price for selling

        // Send the sell order
        if (OrderSend(request, result))
        {
            Print("Sell order sent successfully. Ticket: ", result.retcode, result.deal, result.order);
        }
        else
        {
            Print("Error sending sell order. Error code: ", GetLastError());
        }
    }
    }
}


//+------------------------------------------------------------------+
