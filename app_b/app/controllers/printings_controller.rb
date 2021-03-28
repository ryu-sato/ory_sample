class PrintingsController < ApplicationController
  before_action :set_printing, only: %i[ show edit destroy ]

  # GET /printings or /printings.json
  def index
    @printings = Printing.all
  end

  # GET /printings/1 or /printings/1.json
  def show
  end

  # GET /printings/new
  def new
    @printing = Printing.new
  end

  # POST /printings or /printings.json
  def create
    @printing = Printing.new(printing_params)

    respond_to do |format|
      if @printing.save
        format.html { redirect_to @printing, notice: "Printing was successfully created." }
        format.json { render :show, status: :created, location: @printing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @printing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /printings/1 or /printings/1.json
  def destroy
    @printing.destroy
    respond_to do |format|
      format.html { redirect_to printings_url, notice: "Printing was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_printing
      @printing = Printing.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def printing_params
      params.fetch(:printing, {})
    end
end
