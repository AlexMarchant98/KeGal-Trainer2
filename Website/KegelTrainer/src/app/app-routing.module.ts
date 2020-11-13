import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { PrivacyPolicyComponent} from './privacy-policy/privacy-policy.component'
import { LandingPageComponent } from './landing-page/landing-page.component'
import { ContactComponent } from './contact/contact.component'


const routes: Routes = [
  { path: 'contact', component: ContactComponent},
  { path: 'privacy', component: PrivacyPolicyComponent},
  { path: '', component: LandingPageComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
