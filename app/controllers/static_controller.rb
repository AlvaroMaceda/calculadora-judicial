class StaticController < ApplicationController
  def index
    # Esto hace que no haga falta la vista
    # render(component: 'HelloWorld', props: { greeting: 'test 123' }) 
  end
end
