<template>
  <div class="todos">
    <AppHeader></AppHeader>
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <h3>Servers</h3>

  <p>
      <button class="btn btn-primary" type="button" @click="toggleCollapseAddItem()" >
        Add Server
      </button>
  </p>
  <div v-bind:class="[addItemButton ? 'collapse show' : 'collapse']" >
    <div class="card card-body">
      <input class="form-control"
      autofocus autocomplete="off"
      placeholder="Name"
      v-model="newItemName" />
      <br />
      <input class="form-control"
      autofocus autocomplete="off"
      placeholder="URL BASE"
      v-model="newItemUrlBase" />
      <br />
      <input class="form-control"
      autofocus autocomplete="off"
      placeholder="URL ENDPOINT"
      v-model="newItemUrlEndpoint" />
      <br />
      <button class="btn btn-primary" type="button" @click="addItem" >
        Save
      </button>
    </div>
  </div>
  <br />
    <ul class="list-group">
      <li class="list-group-item" v-for="item in list_items" :key="item.id" :item="item">
        <div v-show="item != editedItem" style="text-align: left;"  @dblclick="editItem(item)">
          <p style="font-size:20px"><strong>{{ item.name }}</strong></p>
          <p v-if="item.status === 'ok'">Status 🥳 <i style="color:green" class="fa fa-check-circle"></i> </p>
          <p v-else>Status 😵<i style="color:red" class="fa fa-exclamation-circle"></i> </p>
          <p>Last check: {{ item.updated_at}}</p>
          <p>URL: {{ item.url_base }}</p>
          <p>END_POINT: {{ item.url_endpoint }}</p>
          <p>Requests: {{item.requests}}</p>
          <p>Errors: {{item.thrown_errors}}</p>
          <i class="fa fa-trash-alt float-right" @click="removeItemAlert(item)"></i>
        </div>
        <div  v-show="item == editedItem">
            <div class="card card-body">
              <input class="form-control"
              autofocus autocomplete="off"
              placeholder="Name"
              v-model="item.name" />
              <br />
              <input class="form-control"
              autofocus autocomplete="off"
              placeholder="URL BASE"
              v-model="item.url_base" />
              <br />
              <input class="form-control"
              autofocus autocomplete="off"
              placeholder="URL ENDPOINT"
              v-model="item.url_endpoint" />
              <br />
              <button class="btn btn-primary" type="button" @click="updateItem(item)" >
                Save
              </button>
            </div>
          </div>
      </li>
    </ul>
  </div>
</template>

<script>
import AppHeader from '@/components/AppHeader'

export default {
  name: 'ListItem',
  data () {
    return {
      list_items: [],
      newItemName: [],
      newItemUrlBase: [],
      newItemUrlEndpoint: [],
      addItemButton: false,
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
    toggleCollapseAddItem () {
      this.addItemButton = !this.addItemButton
    },
    addItem () {
      const value = this.newItemName
      if (!value) {
        return
      }
      this.$http.secured.post('/todos/1/list_items', { list_item: { name: this.newItemName, url_base: this.newItemUrlBase, url_endpoint: this.newItemUrlEndpoint } })
        .then(response => {
          this.list_items.push(response.data)
          this.newItemName = ''
          this.newItemUrlBase = ''
          this.newItemUrlEndpoint = ''
          this.toggleCollapseAddItem()
        })
        .catch(error => this.setError(error, 'Cannot create item'))
    },
    removeItemAlert (item) {
      if (confirm('Are you sure you want to delete ' + item.name + '?')) {
        this.removeItem(item)
      }
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
      this.$http.secured.patch(`/todos/1/list_items/${item.id}`, { list_item: { name: item.name, url_base: item.url_base, url_endpoint: item.url_endpoint } })
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
