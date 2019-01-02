import VueRouter, { RouteConfig } from 'vue-router';
import ThemeSelection from './views/ThemeSelection.vue';
import Settings from './views/Settings.vue';


const routes: RouteConfig[] = [
    {
        path: '/',
        component: ThemeSelection,
    },
    {
        path: '/settings',
        component: Settings,
    },
];

export default new VueRouter({
    routes,
});
