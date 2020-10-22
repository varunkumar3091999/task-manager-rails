class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :sub_tasks, :mark_as_done]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_user.tasks.parent_tasks
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @sub_tasks = @task.sub_tasks
    respond_to do |format|
      format.html
      format.json
      format.pdf { render template: 'tasks/task.pdf', pdf: 'task'}
    end
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  def sub_tasks
    subtask = @task.sub_tasks.new(
      title: params[:title],
      description: params[:description],
      status: :pending,
      user_id: current_user.id
    )
    respond_to do |format|
      if subtask.save
        format.html {redirect_to task_path(id: @task), notice: "Sub task added"}
        format.json {render :show, status: :created, location: @task}
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def mark_as_done
    @task.update(status: :completed)
    if @task.save
      respond_to do |format|
        @task.sub_tasks.update_all(status: :completed)
        @task.normalize_parent_task
        if @task.parent_id.present?
          format.html {redirect_to @task.parent}
        else
          format.html { redirect_to tasks_url, notice: 'Task was successfully updated.' }
          format.json { render :show, status: :ok, location: tasks_url }
        end
      end
    end
  end
  # POST /tasks
  # POST /tasks.json
  def create
    @task = current_user.tasks.new(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        NotificationJobJob.perform_now(@task)
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end
#@task.update(status: :completed)
  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        if @task.parent.present?
          format.html { redirect_to @task.parent, notice: 'Task was successfully updated.' }
          format.json { render :show, status: :ok, location: @task }
        else
          format.html { redirect_to @task, notice: 'Task was successfully updated.' }
          format.json { render :show, status: :ok, location: @task }
        end
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end
# @task.subtasks.new

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    @task.sub_tasks.each do |sub_task|
    sub_tasks.destroy
    end
    respond_to do |format|
      if @task.parent_id.present?
        respond_to do |format|
          format.html {redirect_to @task.parent}
          format.json { head :no_content}
          format.js {render :layout => false}
        end
      else
        format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :status, :assignee, :assigner, :parent_id, image_attributes: [:id, :attachment, :task_id])
    end
end
