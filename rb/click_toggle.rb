# Click toggle method for the play/pause button (standard jQuery no longer has a toggle method for clicking).
class Element
    def click_toggle(proc1, proc2)
        procs = [proc1, proc2]
        self['toggleclicked'] = 0
    
        self.on(:click) do |event|
            element = event.current_target
            tc = element['toggleclicked'].to_i
            self.instance_eval do
                procs[tc].call
            end
            element['toggleclicked'] = (tc + 1) % 2
        end
    end
end