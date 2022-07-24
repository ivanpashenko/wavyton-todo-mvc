
(vcs-checkout once defncall html events bind prnv replaceTo reactive tap l-vars)

(document.head.appendChild (link (rel:"stylesheet" href:"https://todomvc.com/examples/vanillajs/node_modules/todomvc-app-css/index.css")))

(lget tasks (Array))
(= newTask ""
 filter "All"
 editing undefined
 active (tasks.filter (fn task (not task.done))))

(once (is document.readyState "complete")
  (switch window.location.hash
    (case "#/active" (= filter "Active"))
    (case "#/completed" (= filter "Completed")))

  (renderTo "body"
    (div (class:"todoapp")
      (h1 "todos")
      (tap (input (placeholder:"new task" class:"new-todo" autofocus: yes))
        (on it "keydown"
          (if (or (isnt event.keyCode 13) (is it.value.length 0)) return
            (do
              (tasks.push (text: it.value done: no))
              (lset tasks tasks)
              (= it.value "")))))

      (reactive tasks filter editing
        (= active (tasks.filter (fn task (not task.done))))
        (div (class:"main")
          (input (id:"toggleAll" class:"toggle-all" type:"checkbox"))
          (on (label (for:"toggleAll") "Mark all as complete") "click"
            (tasks.map (fn task i (lset tasks[i].done yes))))
          (ul (class:"todo-list")
            (tasks.map
              (fn task i
                (if (or (is filter "All")
                      (and (is filter "Active") (not task.done))
                      (and (is filter "Completed") task.done))
                  (li (class: (if (is editing i) "editing" ""))
                    (div (class:"view")
                      (on (input (type:"checkbox" checked: task.done class:"toggle")) "change"
                        (lset tasks[i].done (not task.done)))
                      (on (label task.text) "dblclick" (= editing i))
                      (on (button (class:"destroy")) "click" (tasks.splice i 1)))
                    (tap (input (class:"edit" value: task.text autofocus: yes))
                      (on it "keydown"
                        (if (or (isnt event.keyCode 13) (is it.value.length 0)) return
                          (do
                            (lset tasks[i] (text: it.value done: task.done))
                            (= editing undefined))))))))))
          (div (class:"footer")
            (span (class:"todo-count") active.length " item" (if (isnt tasks.length 1) "s") " left")
            (ul (class:"filters")
              (defncall filterOption href:"/#" status:"All"
                (li
                  (on (a (href: href class: (if (is filter status) "selected" "")) status) "click"
                    (= filter status))))
              (filterOption "/#/active" "Active")
              (filterOption "/#/completed" "Completed"))
            (on (button (class:"clear-completed") "Clear completed") "click" (lset tasks active))))))))

