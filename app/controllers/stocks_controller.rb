class StocksController < ApplicationController
  def index
  end

  def create
    get_quote(params[:symbol])
    render :nothing => true
  end

  def dashboard
    data = {}
    stocks = Stock.select("symbol").uniq
    stocks.each {|s| get_quote(s.symbol)}
    stocks.each {|s| data[s.symbol] = Stock.where(:symbol => s.symbol)}
    render :json => data
  end

  def delete
    Stock.delete_all
    redirect_to root_path
  end

  private
  def get_quote(symbol)
    symbol = symbol.upcase
    quote = YahooFinance::get_quotes(YahooFinance::StandardQuote, symbol)[symbol].lastTrade
    Stock.create(:symbol => symbol, :quote => quote)
  end
end
