import { Component } from '@angular/core';
import {RouteConfig, ROUTER_DIRECTIVES} from '@angular/router-deprecated';
import {HTTP_PROVIDERS} from '@angular/http'

@Component({
    selector: 'app',
    template: `
        <navigation></navigation>
        <div class="container">
            <router-outlet></router-outlet>
        </div>
        <footer class="navbar-fixed-bottom">
            Handcrafted with 💝 by Mr Robot
        </footer>
    `,
    styles: [`
        footer{ text-align: center; font-size: 10px; color: lightgray; }
    `]
})   
export class AppComponent{}