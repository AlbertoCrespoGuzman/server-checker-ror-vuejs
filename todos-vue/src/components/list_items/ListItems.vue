<template>
  <div class="todos">
    <AppHeader></AppHeader>
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <h3>ListItems</h3>
    <input class="form-control"
      autofocus autocomplete="off"
      placeholder="List item test?"
      v-model="newItem"
      @keyup.enter="addItem" />
    <br />
    <ul class="list-group">
      <li class="list-group-item" v-for="item in list_items" :key="item.id" :item="item">
        <div v-show="item != editedItem" >
          <label>{{ item.name }}</label>
          <i class="fa fa-trash-alt float-right" @click="removeItem(item)"></i>
        </div>
        <div v-show="item == editedItem">
          <input class="form-control"
            v-item-focus
            @keyup.enter="updateItem(item)"
            v-model="item.name"
          />
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import AppHeader from '@/components/AppHeader'

export default {
  name: 'List',
  data () {
    return {
      list_items: [],
      newItem: [],
      error: '',
      editedItem: ''
    }
  },
  created () {
    if (!this.$store.state.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/todos/1/list_items')
        .then(response => {
          this.list_items = response.data
          console.log(JSON.stringify(response.data))
        })
        .catch(error => { this.setError(error, 'Something went wrong') })
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addItem () {
      const value = this.newItem && this.newItem.trim()
      if (!value) {
        return
      }
      this.$http.secured.post('/todos/1/list_items', { list_item: { name: this.newItem, url_base: 'url_base', url_endpoint: 'url_endpoint'} })
        .then(response => {
          this.list_items.push(response.data)
          this.newItem = ''
        })
        .catch(error => this.setError(error, 'Cannot create item'))
    },
    removeItem (item) {
      this.$http.secured.delete(`/todos/1/list_items/${item.id}`)
        .then(response => this.list_items.splice(this.list_items.indexOf(item), 1))
        .catch(error => this.setError(error, 'Cannot delete item'))
    },
    editItem (item) {
      this.editedItem = item
    },
    updateItem (item) {
      this.editedItem = ''
      this.$http.secured.patch(`/todos/1/list_items/${item.id}`, { item: { name: item.name } })
        .catch(error => this.setError(error, 'Cannot update todo'))
    }
  },
  directives: {
    'todo-focus': function (el) {
      el.focus()
    }
  },
  components: { AppHeader }
}
</script>

<style lang="css">
  .todos ul li i.fa.fa-trash-alt {
    cursor: pointer;
    visibility: hidden;
    margin-top: 5px;
  }
  .todos ul li:hover {
    background: #fcfcfc;
  }

  .todos ul li:hover i.fa.fa-trash-alt {
    visibility: visible;
  }
</style>
