class WorksController < ApplicationController

  before_action :find_work, except: [:index, :create, :new]

  def index
    @works = Work.all
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    save = @work.save

    redirect_path = save ? work_path(@work.id) : works_path

    category = "work"

    if (params[:work][:category].is_a? String)
      category = params[:work][:category] unless params[:work][:category].empty?
    end

    error_flash = error_flash("could not create #{category}", @work.errors)

    action_success_check(save, redirect_path, destination_view: :new, success_msg: "Successfully created #{@work.category} #{@work.id}", error_msg: error_flash)
  end

  def show
    redirect_to works_path and return if @work.nil?
  end

  def edit
    redirect_to works_path and return if @work.nil?
  end

  def update
    redirect_to works_path and return if @work.nil?

    update = @work.update(work_params)

    category = "work"

    if (params[:work][:category].is_a? String)
      category = params[:work][:category] unless params[:work][:category].empty?
    end

    error_flash = error_flash("could not update #{category}", @work.errors)

    action_success_check(update, work_path, destination_view: :edit, success_msg: "Successfully updated #{@work.category} #{@work.id}", error_msg: error_flash)
  end

  def destroy
    redirect_to works_path and return if @work.nil?

    action_success_check(@work.destroy, works_path, success_msg: "Successfully destroyed #{@work.category} #{@work.id}")
  end

  def upvote
    redirect_to works_path and return if @work.nil?

    if @current_user.nil?
      flash[:error] = error_flash("A problem occurred: You must log in to do that")
      redirect_to request.referrer and return
    end

    vote = Vote.new(user: @current_user, work: @work)

    save = vote.save

    error_flash = error_flash("A problem occurred: Could not upvote", vote.errors)

    action_success_check(save, work_path(@work.id), success_msg: "Successfully upvoted!", error_msg: error_flash)
  end

  private

  def work_params
    return params.require(:work).permit(:work_id, :title, :description, :publication_date, :creator, :category)
  end

  def find_work
    @work = Work.find_by(id: params[:id].to_i)
  end


end
