/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *  the Software, and to permit persons to whom the Software is furnished to do so,
 *  subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 *  ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 *  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 *  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import TitleBar from '../components/appbar.component.dart';
import {Route, Switch, useLocation} from 'react-router-dom';
import HomePage from '../pages/home.page';
import AboutPage from '../pages/about.page';
import PrivacyPolicyPage from '../pages/privacy_policy.page';
import {useEffect, useState} from 'react';


function PageManager() {
  const location = useLocation();
  const [pageTitle, setPageTitle] = useState('Bookology');
  useEffect(() => {
    if (location.pathname === '/') {
      setPageTitle((pageTitle) => pageTitle);
    }
    if (location.pathname === '/about') {
      setPageTitle((pageTitle) => pageTitle + ' | About');
    }
    if (location.pathname === '/privacy-policy') {
      setPageTitle((pageTitle) => pageTitle + ' | Privacy Policy');
    }
  }, [location.pathname]);

  return (
    <>
      <TitleBar appName={pageTitle}/>
      <Switch>
        <Route path="/" exact>
          <HomePage pageTitle={pageTitle}/>
        </Route>
        <Route path="/about" exact>
          <AboutPage pageTitle={pageTitle.split(' ')[2] + ' | ' + pageTitle.split(' ')[0]}/>
        </Route>
        <Route path="/privacy-policy" exact>
          <PrivacyPolicyPage pageTitle={pageTitle.split(' ')[2] + ' | ' + pageTitle.split(' ')[0]}/>
        </Route>
      </Switch>
    </>
  );
}

export default PageManager;
