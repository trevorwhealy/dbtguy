class TipsController < ApplicationController
  # before_action :authenticate_user!, only: [:new]
  before_action :set_tip, only: [:show, :edit, :update, :destroy, :upvote, :downvote]

  # GET /tips
  # GET /tips.json
  def index
    @tips = Tip.all.where(:approved => true).order(cached_votes_up: :desc)
  end

  def pending
    @tips = Tip.all.where("approved IS ?", nil)
  end

  def all
    @tips = Tip.order(id: :desc)
  end

  def about
  end

  # GET /tips/1
  # GET /tips/1.json
  def show
    @tips = Tip.all
  end

  # GET /tips/new
  def new
    if current_user
      @tip = Tip.new
    else
      redirect_to new_user_registration_path
    end

  end

  # GET /tips/1/edit
  def edit
    unless current_user && current_user.admin == true
      redirect_to root_path
    end
  end

  # POST /tips
  # POST /tips.json
  def create
    @tip = Tip.new(tip_params)
    @tip.user = current_user
    @tip.save

    respond_to do |format|
      if @tip.save
        format.html { redirect_to @tip, notice: 'Tip was successfully created.' }
        format.json { render :show, status: :created, location: @tip }
      else
        format.html { render :new }
        format.json { render json: @tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tips/1
  # PATCH/PUT /tips/1.json
  def update
    respond_to do |format|
      if @tip.update(tip_params)
        format.html { redirect_to @tip, notice: 'Tip was successfully updated.' }
        format.json { render :show, status: :ok, location: @tip }
      else
        format.html { render :edit }
        format.json { render json: @tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tips/1
  # DELETE /tips/1.json
  def destroy
    @tip.destroy
    respond_to do |format|
      format.html { redirect_to tips_url, notice: 'Tip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @tip.upvote_from current_user
    redirect_to :back
  end

  def downvote
    @tip.downvote_from current_user
    redirect_to tips_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tip
      @tip = Tip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tip_params
      params.require(:tip).permit(:title, :author, :caption, :situation, :do, :dont, :quote, :created_at)
    end
end
