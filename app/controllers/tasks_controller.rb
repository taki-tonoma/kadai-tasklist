class TasksController < ApplicationController
    
    before_action :require_user_logged_in
    before_action :correct_user, only: [:destroy, :edit, :update, :show]
    
    def index
        #@tasks = Task.all
        @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end 

    def show
    end 

    def new
        #@task = Task.new
        @task = current_user.tasks.build
    end 
    
   def create
       @task = current_user.tasks.build(tasks_params)
        if @task.save
            flash[:success] = 'Taskを投稿しました。'
            redirect_to root_url
        else
            @tasks = current_user.tasks.order(id: :desc).page(params[:page])
            flash.now[:danger] = 'Taskの投稿に失敗しました。'
            render :new
        end
   end
    
    def edit
    end 
    
    def update
        
        if @task.update(tasks_params)
            flash[:success] = "Taskは正常に更新されました"
            redirect_to @task
        else
            flash.now[:danger] = "Taskは更新されませんでした"
            render :edit
        end
    end 
    
    def destroy 
        @task.destroy
        
        flash[:success] = "Taskは正常に削除されました"
        redirect_to tasks_url
    end 
    
    private
    
    #Strong Parameter
    def tasks_params
        params.require(:task).permit(:content, :status)
    end 
    
    def correct_user
        @task = current_user.tasks.find_by(id: params[:id])
        unless @task 
            redirect_to root_url
        end 
    end 

end