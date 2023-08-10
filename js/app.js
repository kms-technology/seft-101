
function newItemCloseButton() {
  var span = document.createElement('span');

  span.className = 'close';
  span.appendChild(document.createTextNode('\u00D7'));

  return span;
}

function addCloseBtnToTodoItems() {
  var todoItems = document.getElementsByTagName('li');

  for (var i = 0; i < todoItems.length; ++i) {
    todoItems[i].appendChild(newItemCloseButton());
  }
}

function handleClickCloseBtn() {
  var closes = document.getElementsByClassName('close');

  for (var i = 0; i < closes.length; ++i) {
    closes[i].onclick = function() {
      var div = this.parentElement;
      div.style.display = 'none';
    }
  }
}

function handleClickTodoItem() {
  var todoList = document.querySelector('ul');

  todoList.addEventListener('click', function(event) {
    if (event.target.tagName === 'LI') {
      // Add the toggle below this comment: event.target.classList.toggle('class-name')
      event.target.classList.toggle('completed-item')
    }
  }, false);
}

// Add new todo item when clicking on the "Add" button
function newTodoItem() {
  var li = document.createElement('li');
  var inputValue = document.getElementById('todo-input').value;
  li.appendChild(document.createTextNode(inputValue));

  if (inputValue === '') {
    alert('You must write something!');
  } else {
    document.getElementById('todo-list').appendChild(li);
  }
  document.getElementById('todo-input').value = '';

  li.appendChild(newItemCloseButton());
  handleClickCloseBtn();
}

addCloseBtnToTodoItems();
handleClickCloseBtn();
handleClickTodoItem();
