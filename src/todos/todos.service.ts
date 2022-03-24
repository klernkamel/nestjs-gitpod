import { Injectable } from '@nestjs/common';
import { CreateTodoDto } from './dto/create-todo.dto';
import { UpdateTodoDto } from './dto/update-todo.dto';
import { Todo } from './entities/todo.entity';

let todos: Todo[]  = [];

@Injectable()
export class TodosService {
  create(createTodoDto: CreateTodoDto) {
    todos.push(createTodoDto)
    return createTodoDto;
  }

  findAll() {
    return todos;
  }

  findOne(id: number) {
    return todos[id];
  }

  update(id: number, updateTodoDto: UpdateTodoDto) {
    todos[id] = updateTodoDto;
    return updateTodoDto;
  }

  remove(id: number) {
    todos = todos.filter((x, index) => {
      return index !== id;
    })
    return todos;
  }
}
