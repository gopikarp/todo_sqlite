# sqlite

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

todo list screen detailed explanation

// The state for TodoListScreen
class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TodoRepository _todoRepository = TodoRepository(); // Creating a repository instance

  List<Todo> _todos = []; // List to store Todos

  @override
  void initState() {
    super.initState();
    _loadTodos(); // Load todos when the screen initializes
  }

  // Function to load todos from the repository
  void _loadTodos() async {
    final todos = await _todoRepository.getAllTodos(); // Fetch todos from the repository
    setState(() {
      _todos = todos; // Update the state with the fetched todos
    });
  }

  // Function to add a new todo
  void _addTodo() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    if (name.isNotEmpty && description.isNotEmpty) {
      final todo = Todo(name: name, description: description);
      await _todoRepository.insert(todo); // Insert the new todo into the repository
      _nameController.clear();
      _descriptionController.clear();
      _loadTodos(); // Reload the todos list
    }
  }

  // Function to update a todo
  void _updateTodo(Todo todo) async {
    final updatedTodo = Todo(
      id: todo.id,
      name: _nameController.text,
      description: _descriptionController.text,
    );
    await _todoRepository.update(updatedTodo); // Update the todo in the repository
    _nameController.clear();
    _descriptionController.clear();
    _loadTodos(); // Reload the todos list
  }

  // Function to delete a todo
  void _deleteTodo(int id) async {
    await _todoRepository.delete(id); // Delete the todo from the repository
    _loadTodos(); // Reload the todos list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Text fields for entering todo name and description
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Todo Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addTodo(); // Add a new todo
                  },
                  child: Text('Add Todo'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(todo.name),
                  subtitle: Text(todo.description),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _nameController.text = todo.name;
                      _descriptionController.text = todo.description;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Edit Todo'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration:
                                    InputDecoration(labelText: 'Todo Name'),
                              ),
                              TextField(
                                controller: _descriptionController,
                                decoration:
                                    InputDecoration(labelText: 'Description'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _updateTodo(todo); // Update the selected todo
                                Navigator.of(context).pop();
                              },
                              child: Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Delete Todo'),
                        content: Text(
                            'Are you sure you want to delete this todo?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteTodo(todo.id!); // Delete the selected todo
                              Navigator.of(context).pop();
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
