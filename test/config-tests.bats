#!/usr/bin/env bats

if [ "${PATH#*/usr/local/skynet/bin*}" = "$PATH" ]; then
    . /etc/profile.d/skynet.sh
fi

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'
load 'test_helper/bats-file/load'

function random() {
head /dev/urandom | tr -dc 0-9 | head -c$1
}

function setup() {
    # echo "# Setup_file" > &3
    if [ $BATS_TEST_NUMBER = 1 ]; then
        echo 'user=test-5285' > /tmp/skynet-test-env.sh
        echo 'user2=test-5286' >> /tmp/skynet-test-env.sh
        echo 'userbk=testbk-5285' >> /tmp/skynet-test-env.sh
        echo 'userpass1=test-5285' >> /tmp/skynet-test-env.sh
        echo 'userpass2=t3st-p4ssw0rd' >> /tmp/skynet-test-env.sh
        echo 'skynet=/usr/local/skynet' >> /tmp/skynet-test-env.sh
        echo 'domain=test-5285.hestiacp.com' >> /tmp/skynet-test-env.sh
        echo 'domainuk=test-5285.hestiacp.com.uk' >> /tmp/skynet-test-env.sh
        echo 'rootdomain=testskynetcp.com' >> /tmp/skynet-test-env.sh
        echo 'subdomain=cdn.testskynetcp.com' >> /tmp/skynet-test-env.sh
        echo 'database=test-5285_database' >> /tmp/skynet-test-env.sh
        echo 'dbuser=test-5285_dbuser' >> /tmp/skynet-test-env.sh
    fi

    source /tmp/skynet-test-env.sh
    source $SKYNET/func/main.sh
    source $SKYNET/conf/skynet.conf
    source $SKYNET/func/ip.sh
}

@test "Setup Test domain" {
    run v-add-user $user $user $user@skynetcp.com default "Super Test"
    assert_success
    refute_output

    run v-add-web-domain $user 'testskynetcp.com'
    assert_success
    refute_output

    ssl=$(v-generate-ssl-cert "testskynetcp.com" "info@testskynetcp.com" US CA "Orange County" skynetcp IT "mail.$domain" | tail -n1 | awk '{print $2}')
    mv $ssl/testskynetcp.com.crt /tmp/testskynetcp.com.crt
    mv $ssl/testskynetcp.com.key /tmp/testskynetcp.com.key

    # Use self signed certificates during last test
    run v-add-web-domain-ssl $user testskynetcp.com /tmp
    assert_success
    refute_output
}

@test "Web Config test" {
    for template in $(v-list-web-templates plain); do
        run v-change-web-domain-tpl $user testskynetcp.com $template
        assert_success
        refute_output
    done
}

@test "Proxy Config test" {
    if [ "$PROXY_SYSTEM" = "nginx" ]; then
        for template in $(v-list-proxy-templates plain); do
            run v-change-web-domain-proxy-tpl $user testskynetcp.com $template
            assert_success
            refute_output
        done
    else
        skip "Proxy not installed"
    fi
}

@test "Clean up" {
    run v-delete-user $user
    assert_success
    refute_output
}
