class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
    @categories = Category.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @users  = @course.users
    @topics = @course.topics
    # @category = @course.category
    #@courses = User.find(params[:id]).courses
  end

  # GET /courses/new
  def new
    #@course = Course.new
    @course = Course.new(:category_id => params[:category])
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    @course.author_id = current_user.id;

    respond_to do |format|
      if @course.save
        current_user.join_course(@course)
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :description, :content, :category_id)
    end

    def correct_user
      @course = Course.find(params[:id])
      redirect_to(root_url) unless (@course.author_id == current_user.id)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
