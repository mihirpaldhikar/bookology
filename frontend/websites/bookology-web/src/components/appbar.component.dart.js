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

import React from 'react';
import PropTypes from 'prop-types';
import {AppBar, Box, Button, makeStyles, Toolbar, Typography} from "@material-ui/core";
import "../css/theme.css";

const styles = makeStyles((theme) => ({
    root: {
        flexGrow: 1,
    },
    menuButton: {
        marginRight: theme.spacing(2),
    },
    title: {
        flexGrow: 1,
    },
    button: {
        fontWeight: "bold",
        fontSize: 12,
        borderRadius: 100,
    },
}));

function TitleBar(props) {
    const style = styles();
    return (
        <AppBar position="static" elevation={0} color="secondary">
            <Toolbar>
                <Typography  variant="h6" className={style.title}>
                    {props.appName}
                </Typography>
                <Box marginRight={2} border={1} borderRadius={100} borderColor="#000000">
                    <Button color="inherit" className={style.button}>Login</Button>
                </Box>
                <Box border={1} borderRadius={100} borderColor="#000000">
                    <Button color="inherit" className={style.button}>
                        Sign Up
                    </Button>
                </Box>
            </Toolbar>
        </AppBar>
    );
}

TitleBar.propTypes = {
    appName: PropTypes.string.isRequired,
};


export default TitleBar;
