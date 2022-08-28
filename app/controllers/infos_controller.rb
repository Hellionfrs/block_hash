require 'net/http'
require 'json'

class InfosController < ApplicationController
  before_action :set_info, only: %i[ show edit update destroy ]

  # GET /infos or /infos.json
  def index
    @infos = Info.all
  end

  # GET /infos/1 or /infos/1.json
  def show
  end

  # GET /infos/new
  def new
    @info = Info.new
  end

  # GET /infos/1/edit
  def edit
  end

  # POST /infos or /infos.json
  def create
    @info = Info.new(info_params)
    
    @info.block_hash = request_api(@info.block)
    
    respond_to do |format|
      if @info.save
        format.turbo_stream
        format.html { redirect_to info_url(@info), notice: "Info was successfully created." }
        format.json { render :show, status: :created, location: @info }
      else
        format.turbo_stream { render turbo_stream: turbo_stream
          .replace("#{helpers.dom_id(@info)}_form", partial: "form", locals: {info: @info})}
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /infos/1 or /infos/1.json
  def update
    respond_to do |format|
      if @info.update(info_params)
        format.html { redirect_to info_url(@info), notice: "Info was successfully updated." }
        format.json { render :show, status: :ok, location: @info }
      else
        format.turbo_stream { render turbo_stream: turbo_stream
          .replace("#{helpers.dom_id(@info)}_form", partial: "form", locals: {info: @info})}
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /infos/1 or /infos/1.json
  def destroy
    @info.destroy

    respond_to do |format|
      format.turbo_stream {render turbo_stream:
      turbo_stream.remove("#{helpers.dom_id(@info)}_item")}
      format.html { redirect_to infos_url, notice: "Info was successfully destroyed." }
    end
  end
  def request_api(block)
    
    uri = URI("https://blockchain.info/rawblock/#{block}")
    res = Net::HTTP.get(uri)
    status = Net::HTTP.get_response(uri)
    if status.kind_of? Net::HTTPSuccess
      json = JSON.parse(res)
    end
    # when Net::HTTPUnauthorized
    #   {'error' => "#{res.message}: username and password set and correct?"}
    # when Net::HTTPServerError
    #   {'error' => "#{res.message}: try again later?"}
    # else
    #   {'error' => res.message}
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_info
      @info = Info.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def info_params
      params.require(:info).permit(:block)
    end
end
