import { Component } from '@angular/core';
import {ROUTER_DIRECTIVES} from '@angular/router-deprecated';

@Component({
    selector: 'navigation',
    template: `
        <nav class="navbar navbar-default navbar-fixed-top">
            <div class="container-fluid">
                <div class="navbar-header">
                    <a class="navbar-brand">WriteMynd</a>
                </div>
                <div class="collapse navbar-collapse">
                    <ul class="nav navbar-nav navbar-right">
                        <li><a routerLink="/reported_post">Reported Posts</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    `,
    styles: [`

    `]
})
export class NavigationComponent{}